import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';

class ImportResolver {
  final AppDatabase _db;

  ImportResolver(this._db);

  Future<void> executeOverwrite(Map<String, dynamic> data) async {
    await _db.transaction(() async {
      await _db.delete(_db.progressLogs).go();
      await _db.delete(_db.workTags).go();
      await _db.delete(_db.tags).go();
      await _db.delete(_db.works).go();

      await _insertAll(data);
    });
  }

  Future<void> executeMerge(Map<String, dynamic> data) async {
    final rawWorks = (data['works'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawLogs =
        (data['progress_logs'] as List? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      // 1. Process works
      for (final w in rawWorks) {
        final id = w['id'] as String;
        final existing = await (_db.select(_db.works)
              ..where((tbl) => tbl.id.equals(id)))
            .getSingleOrNull();

        final importUpdatedAt = DateTime.parse(
            w['updated_at'] as String? ?? DateTime.now().toIso8601String());

        if (existing == null) {
          // New work
          await _insertWorkFromMap(w);
        } else if (importUpdatedAt.isAfter(existing.updatedAt)) {
          // Last write wins: replace existing work
          await _updateWorkFromMap(w);
        }
      }

      // 2. Process progress logs (union-merge by ID)
      for (final l in rawLogs) {
        final id = l['id'] as String;
        final existing = await (_db.select(_db.progressLogs)
              ..where((tbl) => tbl.id.equals(id)))
            .getSingleOrNull();

        if (existing == null) {
          // Check if parent work exists
          final workId = l['work_id'] as String;
          final parentWork = await (_db.select(_db.works)
                ..where((tbl) => tbl.id.equals(workId)))
              .getSingleOrNull();

          if (parentWork != null) {
            await _db.into(_db.progressLogs).insert(
                  ProgressLog(
                    id: id,
                    workId: workId,
                    progressUnit: l['progress_unit'] as String? ?? 'chapter',
                    progressValue: (l['progress_value'] as num).toInt(),
                    volumeValue: (l['volume_value'] as num?)?.toInt(),
                    note: l['note'] as String?,
                    recordedAt: DateTime.parse(l['recorded_at'] as String),
                  ),
                );
          }
        }
      }
    });
  }

  Future<void> _insertAll(Map<String, dynamic> data) async {
    final rawWorks = (data['works'] as List? ?? []).cast<Map<String, dynamic>>();
    final rawLogs =
        (data['progress_logs'] as List? ?? []).cast<Map<String, dynamic>>();

    for (final w in rawWorks) {
      await _insertWorkFromMap(w);
    }

    for (final l in rawLogs) {
      await _db.into(_db.progressLogs).insert(
            ProgressLog(
              id: l['id'] as String,
              workId: l['work_id'] as String,
              progressUnit: l['progress_unit'] as String? ?? 'chapter',
              progressValue: (l['progress_value'] as num).toInt(),
              volumeValue: (l['volume_value'] as num?)?.toInt(),
              note: l['note'] as String?,
              recordedAt: DateTime.parse(l['recorded_at'] as String),
            ),
          );
    }
  }

  Future<void> _insertWorkFromMap(Map<String, dynamic> w) async {
    final progressMap = w['progress'] as Map<String, dynamic>? ?? {};
    final additionalUrls = w['additional_urls'];
    final additionalUrlsJson = additionalUrls is List
        ? jsonEncode(additionalUrls)
        : (additionalUrls is String ? additionalUrls : '[]');

    final work = Work(
      id: w['id'] as String,
      title: w['title'] as String,
      author: w['author'] as String?,
      sourceUrl: w['source_url'] as String?,
      additionalUrls: additionalUrlsJson,
      format: w['format'] as String? ?? 'web_novel',
      status: w['status'] as String? ?? 'reading',
      publicationStatus: w['publication_status'] as String? ?? 'ongoing',
      coverPath: w['cover_path'] as String?,
      progressUnit: progressMap['unit'] as String? ?? 'chapter',
      currentProgress: (progressMap['current'] as num? ?? 0).toInt(),
      totalProgress: (progressMap['total'] as num?)?.toInt(),
      currentVolume: (progressMap['current_volume'] as num?)?.toInt(),
      totalVolumes: (progressMap['total_volumes'] as num?)?.toInt(),
      rating: (w['rating'] as num?)?.toInt(),
      notes: w['notes'] as String?,
      synopsis: w['synopsis'] as String?,
      createdAt: DateTime.parse(
          w['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          w['updated_at'] as String? ?? DateTime.now().toIso8601String()),
      startedAt: w['started_at'] != null
          ? DateTime.parse(w['started_at'] as String)
          : null,
      completedAt: w['completed_at'] != null
          ? DateTime.parse(w['completed_at'] as String)
          : null,
      lastReadAt: w['last_read_at'] != null
          ? DateTime.parse(w['last_read_at'] as String)
          : null,
    );

    await _db.into(_db.works).insert(work);

    // Tags
    final tags = (w['tags'] as List? ?? []).cast<String>();
    for (final tagStr in tags) {
      if (tagStr.trim().isEmpty) continue;
      final clean = tagStr.trim();
      var tag = await (_db.select(_db.tags)
            ..where((t) => t.name.collate(Collate.noCase).equals(clean)))
          .getSingleOrNull();

      if (tag == null) {
        tag = Tag(id: clean.toLowerCase().replaceAll(' ', '-'), name: clean);
        await _db.into(_db.tags).insert(tag, mode: InsertMode.insertOrIgnore);
      }

      await _db.into(_db.workTags).insert(
            WorkTagsCompanion(
              workId: Value(work.id),
              tagId: Value(tag.id),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  Future<void> _updateWorkFromMap(Map<String, dynamic> w) async {
    final id = w['id'] as String;
    final progressMap = w['progress'] as Map<String, dynamic>? ?? {};
    final additionalUrls = w['additional_urls'];
    final additionalUrlsJson = additionalUrls is List
        ? jsonEncode(additionalUrls)
        : (additionalUrls is String ? additionalUrls : '[]');

    await (_db.update(_db.works)..where((tbl) => tbl.id.equals(id))).write(
      WorksCompanion(
        title: Value(w['title'] as String),
        author: Value(w['author'] as String?),
        sourceUrl: Value(w['source_url'] as String?),
        additionalUrls: Value(additionalUrlsJson),
        format: Value(w['format'] as String? ?? 'web_novel'),
        status: Value(w['status'] as String? ?? 'reading'),
        publicationStatus:
            Value(w['publication_status'] as String? ?? 'ongoing'),
        coverPath: Value(w['cover_path'] as String?),
        progressUnit: Value(progressMap['unit'] as String? ?? 'chapter'),
        currentProgress: Value((progressMap['current'] as num? ?? 0).toInt()),
        totalProgress: Value((progressMap['total'] as num?)?.toInt()),
        currentVolume: Value((progressMap['current_volume'] as num?)?.toInt()),
        totalVolumes: Value((progressMap['total_volumes'] as num?)?.toInt()),
        rating: Value((w['rating'] as num?)?.toInt()),
        notes: Value(w['notes'] as String?),
        synopsis: Value(w['synopsis'] as String?),
        createdAt: Value(DateTime.parse(
            w['created_at'] as String? ?? DateTime.now().toIso8601String())),
        updatedAt: Value(DateTime.parse(
            w['updated_at'] as String? ?? DateTime.now().toIso8601String())),
        startedAt: Value(w['started_at'] != null
            ? DateTime.parse(w['started_at'] as String)
            : null),
        completedAt: Value(w['completed_at'] != null
            ? DateTime.parse(w['completed_at'] as String)
            : null),
        lastReadAt: Value(w['last_read_at'] != null
            ? DateTime.parse(w['last_read_at'] as String)
            : null),
      ),
    );

    // Update tags
    await (_db.delete(_db.workTags)..where((wt) => wt.workId.equals(id))).go();
    final tags = (w['tags'] as List? ?? []).cast<String>();
    for (final tagStr in tags) {
      if (tagStr.trim().isEmpty) continue;
      final clean = tagStr.trim();
      var tag = await (_db.select(_db.tags)
            ..where((t) => t.name.collate(Collate.noCase).equals(clean)))
          .getSingleOrNull();

      if (tag == null) {
        tag = Tag(id: clean.toLowerCase().replaceAll(' ', '-'), name: clean);
        await _db.into(_db.tags).insert(tag, mode: InsertMode.insertOrIgnore);
      }

      await _db.into(_db.workTags).insert(
            WorkTagsCompanion(
              workId: Value(id),
              tagId: Value(tag.id),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }
}
