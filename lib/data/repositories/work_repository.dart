import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/enums/reading_status.dart';
import '../database/app_database.dart';
import 'progress_log_repository.dart';
import 'tag_repository.dart';

class WorkWithTags {
  final Work work;
  final List<Tag> tags;

  const WorkWithTags({
    required this.work,
    required this.tags,
  });

  WorkWithTags copyWith({
    Work? work,
    List<Tag>? tags,
  }) {
    return WorkWithTags(
      work: work ?? this.work,
      tags: tags ?? this.tags,
    );
  }
}

class WorkRepository {
  final AppDatabase _db;
  final TagRepository _tagRepo;
  final ProgressLogRepository _progressLogRepo;
  final Uuid _uuid;

  WorkRepository(
    this._db,
    this._tagRepo,
    this._progressLogRepo, [
    Uuid? uuid,
  ]) : _uuid = uuid ?? const Uuid();

  Stream<List<WorkWithTags>> watchWorksWithTags({
    ReadingStatus? status,
    String? searchQuery,
    String? format,
    String? tagFilter,
    String sortBy = 'last_read', // 'last_read', 'title', 'rating', 'created'
  }) {
    final query = _db.select(_db.works).join([
      leftOuterJoin(_db.workTags, _db.workTags.workId.equalsExp(_db.works.id)),
      leftOuterJoin(_db.tags, _db.tags.id.equalsExp(_db.workTags.tagId)),
    ]);

    if (status != null) {
      query.where(_db.works.status.equals(status.value));
    }

    if (format != null && format.isNotEmpty && format != 'all') {
      query.where(_db.works.format.equals(format));
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = '%${searchQuery.trim()}%';
      query.where(_db.works.title.like(q) |
          _db.works.author.like(q) |
          _db.tags.name.like(q));
    }

    // Apply sorting
    switch (sortBy) {
      case 'title':
        query.orderBy([OrderingTerm.asc(_db.works.title)]);
        break;
      case 'rating':
        query.orderBy([
          OrderingTerm(
            expression: _db.works.rating,
            mode: OrderingMode.desc,
            nulls: NullsOrder.last,
          ),
          OrderingTerm.desc(_db.works.updatedAt),
        ]);
        break;
      case 'created':
        query.orderBy([OrderingTerm.desc(_db.works.createdAt)]);
        break;
      case 'last_read':
      default:
        query.orderBy([
          OrderingTerm(
            expression: _db.works.lastReadAt,
            mode: OrderingMode.desc,
            nulls: NullsOrder.last,
          ),
          OrderingTerm.desc(_db.works.updatedAt),
        ]);
        break;
    }

    return query.watch().map((rows) {
      final Map<String, WorkWithTags> grouped = {};

      for (final row in rows) {
        final work = row.readTable(_db.works);
        final tag = row.readTableOrNull(_db.tags);

        if (!grouped.containsKey(work.id)) {
          grouped[work.id] = WorkWithTags(work: work, tags: []);
        }

        if (tag != null &&
            !grouped[work.id]!.tags.any((t) => t.id == tag.id)) {
          grouped[work.id]!.tags.add(tag);
        }
      }

      var list = grouped.values.toList();

      // If filtering by a specific tag
      if (tagFilter != null && tagFilter.isNotEmpty) {
        list = list
            .where((item) =>
                item.tags.any((t) => t.name.toLowerCase() == tagFilter.toLowerCase()))
            .toList();
      }

      return list;
    });
  }

  Future<WorkWithTags?> getWorkWithTags(String id) async {
    final work = await (_db.select(_db.works)..where((w) => w.id.equals(id)))
        .getSingleOrNull();
    if (work == null) return null;

    final tags = await _tagRepo.getTagsForWork(id);
    return WorkWithTags(work: work, tags: tags);
  }

  Stream<WorkWithTags?> watchWorkWithTags(String id) {
    final query = _db.select(_db.works).join([
      leftOuterJoin(_db.workTags, _db.workTags.workId.equalsExp(_db.works.id)),
      leftOuterJoin(_db.tags, _db.tags.id.equalsExp(_db.workTags.tagId)),
    ])..where(_db.works.id.equals(id));

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final work = rows.first.readTable(_db.works);
      final tags = <Tag>[];
      for (final row in rows) {
        final tag = row.readTableOrNull(_db.tags);
        if (tag != null && !tags.any((t) => t.id == tag.id)) {
          tags.add(tag);
        }
      }
      return WorkWithTags(work: work, tags: tags);
    });
  }

  Stream<Map<String, int>> watchStatusCounts() {
    return _db.select(_db.works).watch().map((works) {
      final counts = <String, int>{
        'all': works.length,
        'reading': 0,
        'plan_to_read': 0,
        'on_hold': 0,
        'completed': 0,
        'dropped': 0,
      };

      for (final work in works) {
        counts[work.status] = (counts[work.status] ?? 0) + 1;
      }

      return counts;
    });
  }

  Future<String> createWork({
    String? id,
    required String title,
    String? author,
    String? sourceUrl,
    String additionalUrlsJson = '[]',
    String format = 'web_novel',
    String status = 'reading',
    String publicationStatus = 'ongoing',
    String? coverPath,
    String progressUnit = 'chapter',
    int currentProgress = 0,
    int? totalProgress,
    int? currentVolume,
    int? totalVolumes,
    int? rating,
    String? notes,
    String? synopsis,
    List<String> tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastReadAt,
  }) async {
    final workId = id ?? _uuid.v4();
    final now = DateTime.now();

    DateTime? effectiveStartedAt = startedAt;
    if (effectiveStartedAt == null && status == ReadingStatus.reading.value) {
      effectiveStartedAt = now;
    }

    DateTime? effectiveCompletedAt = completedAt;
    if (effectiveCompletedAt == null &&
        status == ReadingStatus.completed.value) {
      effectiveCompletedAt = now;
    }

    final work = Work(
      id: workId,
      title: title.trim(),
      author: author?.trim().isEmpty == true ? null : author?.trim(),
      sourceUrl: sourceUrl?.trim().isEmpty == true ? null : sourceUrl?.trim(),
      additionalUrls: additionalUrlsJson,
      format: format,
      status: status,
      publicationStatus: publicationStatus,
      coverPath: coverPath,
      progressUnit: progressUnit,
      currentProgress: currentProgress < 0 ? 0 : currentProgress,
      totalProgress: totalProgress,
      currentVolume: currentVolume,
      totalVolumes: totalVolumes,
      rating: rating,
      notes: notes,
      synopsis: synopsis,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      startedAt: effectiveStartedAt,
      completedAt: effectiveCompletedAt,
      lastReadAt: lastReadAt ?? (currentProgress > 0 ? now : null),
    );

    await _db.transaction(() async {
      await _db.into(_db.works).insert(work);
      await _tagRepo.setTagsForWork(workId, tags);

      if (currentProgress > 0) {
        await _progressLogRepo.addLog(
          workId: workId,
          progressUnit: progressUnit,
          progressValue: currentProgress,
          volumeValue: currentVolume,
          note: 'Initial progress',
          recordedAt: work.lastReadAt ?? now,
        );
      }
    });

    return workId;
  }

  Future<void> updateWork({
    required String id,
    required String title,
    String? author,
    String? sourceUrl,
    String additionalUrlsJson = '[]',
    required String format,
    required String status,
    required String publicationStatus,
    String? coverPath,
    required String progressUnit,
    required int currentProgress,
    int? totalProgress,
    int? currentVolume,
    int? totalVolumes,
    int? rating,
    String? notes,
    String? synopsis,
    List<String>? tags,
    DateTime? startedAt,
    DateTime? completedAt,
  }) async {
    final existing = await (_db.select(_db.works)
          ..where((w) => w.id.equals(id)))
        .getSingleOrNull();

    if (existing == null) return;

    final now = DateTime.now();

    DateTime? effectiveStartedAt = startedAt ?? existing.startedAt;
    if (effectiveStartedAt == null && status == ReadingStatus.reading.value) {
      effectiveStartedAt = now;
    }

    DateTime? effectiveCompletedAt = completedAt ?? existing.completedAt;
    if (effectiveCompletedAt == null &&
        status == ReadingStatus.completed.value) {
      effectiveCompletedAt = now;
    }

    final bool progressChanged = existing.currentProgress != currentProgress ||
        existing.currentVolume != currentVolume;

    DateTime? effectiveLastReadAt = existing.lastReadAt;
    if (progressChanged) {
      effectiveLastReadAt = now;
    }

    await _db.transaction(() async {
      await (_db.update(_db.works)..where((w) => w.id.equals(id))).write(
        WorksCompanion(
          title: Value(title.trim()),
          author: Value(author?.trim().isEmpty == true ? null : author?.trim()),
          sourceUrl: Value(
              sourceUrl?.trim().isEmpty == true ? null : sourceUrl?.trim()),
          additionalUrls: Value(additionalUrlsJson),
          format: Value(format),
          status: Value(status),
          publicationStatus: Value(publicationStatus),
          coverPath: Value(coverPath),
          progressUnit: Value(progressUnit),
          currentProgress: Value(currentProgress < 0 ? 0 : currentProgress),
          totalProgress: Value(totalProgress),
          currentVolume: Value(currentVolume),
          totalVolumes: Value(totalVolumes),
          rating: Value(rating),
          notes: Value(notes),
          synopsis: Value(synopsis),
          updatedAt: Value(now),
          startedAt: Value(effectiveStartedAt),
          completedAt: Value(effectiveCompletedAt),
          lastReadAt: Value(effectiveLastReadAt),
        ),
      );

      if (tags != null) {
        await _tagRepo.setTagsForWork(id, tags);
      }

      if (progressChanged) {
        await _progressLogRepo.addLog(
          workId: id,
          progressUnit: progressUnit,
          progressValue: currentProgress,
          volumeValue: currentVolume,
          note: null,
          recordedAt: now,
        );
      }
    });
  }

  Future<void> incrementProgress(String workId) async {
    final existing = await (_db.select(_db.works)
          ..where((w) => w.id.equals(workId)))
        .getSingleOrNull();

    if (existing == null) return;

    final now = DateTime.now();
    final newProgress = existing.currentProgress + 1;

    // Transition from plan_to_read to reading on increment
    String newStatus = existing.status;
    DateTime? startedAt = existing.startedAt;
    if (existing.status == ReadingStatus.planToRead.value) {
      newStatus = ReadingStatus.reading.value;
      startedAt ??= now;
    }

    // Auto complete if total progress exists and reached
    DateTime? completedAt = existing.completedAt;
    if (existing.totalProgress != null &&
        newProgress >= existing.totalProgress! &&
        newStatus == ReadingStatus.reading.value) {
      newStatus = ReadingStatus.completed.value;
      completedAt ??= now;
    }

    await _db.transaction(() async {
      await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          currentProgress: Value(newProgress),
          status: Value(newStatus),
          startedAt: Value(startedAt),
          completedAt: Value(completedAt),
          lastReadAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await _progressLogRepo.addLog(
        workId: workId,
        progressUnit: existing.progressUnit,
        progressValue: newProgress,
        volumeValue: existing.currentVolume,
        note: null,
        recordedAt: now,
      );
    });
  }

  Future<void> decrementProgress(String workId) async {
    final existing = await (_db.select(_db.works)
          ..where((w) => w.id.equals(workId)))
        .getSingleOrNull();

    if (existing == null || existing.currentProgress <= 0) return;

    final now = DateTime.now();
    final newProgress = existing.currentProgress - 1;

    await _db.transaction(() async {
      await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          currentProgress: Value(newProgress),
          lastReadAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await _progressLogRepo.addLog(
        workId: workId,
        progressUnit: existing.progressUnit,
        progressValue: newProgress,
        volumeValue: existing.currentVolume,
        note: null,
        recordedAt: now,
      );
    });
  }

  Future<void> updateProgressDirect({
    required String workId,
    required int progressValue,
    int? volumeValue,
    String? note,
  }) async {
    final existing = await (_db.select(_db.works)
          ..where((w) => w.id.equals(workId)))
        .getSingleOrNull();

    if (existing == null) return;

    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.works)..where((w) => w.id.equals(workId))).write(
        WorksCompanion(
          currentProgress: Value(progressValue < 0 ? 0 : progressValue),
          currentVolume: Value(volumeValue ?? existing.currentVolume),
          lastReadAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      await _progressLogRepo.addLog(
        workId: workId,
        progressUnit: existing.progressUnit,
        progressValue: progressValue,
        volumeValue: volumeValue ?? existing.currentVolume,
        note: note,
        recordedAt: now,
      );
    });
  }

  Future<void> deleteWork(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.progressLogs)..where((l) => l.workId.equals(id)))
          .go();
      await (_db.delete(_db.workTags)..where((wt) => wt.workId.equals(id)))
          .go();
      await (_db.delete(_db.works)..where((w) => w.id.equals(id))).go();
    });
    await _tagRepo.cleanupUnusedTags();
  }

  Future<void> clearAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.progressLogs).go();
      await _db.delete(_db.workTags).go();
      await _db.delete(_db.tags).go();
      await _db.delete(_db.works).go();
    });
  }
}
