import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/progress_log_entry.dart';
import '../database/app_database.dart';

class ProgressLogRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  ProgressLogRepository(this._db, [Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  Stream<List<ProgressLog>> watchLogsForWork(String workId) {
    return (_db.select(_db.progressLogs)
          ..where((l) => l.workId.equals(workId))
          ..orderBy([
            (l) => OrderingTerm.desc(l.recordedAt),
            (l) => OrderingTerm.desc(l.rowId),
          ]))
        .watch();
  }

  Stream<List<ProgressLogEntry>> watchLogEntriesForWork(String workId) {
    return watchLogsForWork(workId)
        .map((logs) => logs.map(ProgressLogEntry.fromDrift).toList());
  }

  Future<List<ProgressLog>> getLogsForWork(String workId, {int? limit}) {
    final query = (_db.select(_db.progressLogs)
      ..where((l) => l.workId.equals(workId))
      ..orderBy([
        (l) => OrderingTerm.desc(l.recordedAt),
        (l) => OrderingTerm.desc(l.rowId),
      ]));

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }

  Future<List<ProgressLogEntry>> getLogEntriesForWork(String workId, {int? limit}) async {
    final logs = await getLogsForWork(workId, limit: limit);
    return logs.map(ProgressLogEntry.fromDrift).toList();
  }

  Future<ProgressLog> addLog({
    required String workId,
    required String progressUnit,
    required int progressValue,
    int? volumeValue,
    String? note,
    DateTime? recordedAt,
    String? customId,
  }) async {
    final log = ProgressLog(
      id: customId ?? _uuid.v4(),
      workId: workId,
      progressUnit: progressUnit,
      progressValue: progressValue,
      volumeValue: volumeValue,
      note: note,
      recordedAt: recordedAt ?? DateTime.now(),
    );

    await _db.into(_db.progressLogs).insert(log);
    return log;
  }

  Future<ProgressLog?> getLatestLogForWork(String workId) async {
    final logs = await getLogsForWork(workId, limit: 1);
    return logs.isEmpty ? null : logs.first;
  }

  Future<void> updateLog({
    required String id,
    int? progressValue,
    int? volumeValue,
    String? note,
    DateTime? recordedAt,
  }) async {
    await (_db.update(_db.progressLogs)..where((l) => l.id.equals(id))).write(
      ProgressLogsCompanion(
        progressValue: progressValue == null ? const Value.absent() : Value(progressValue),
        volumeValue: volumeValue == null ? const Value.absent() : Value(volumeValue),
        note: note == null ? const Value.absent() : Value(note),
        recordedAt: recordedAt == null ? const Value.absent() : Value(recordedAt),
      ),
    );
  }

  Future<void> deleteLog(String id) {
    return (_db.delete(_db.progressLogs)..where((l) => l.id.equals(id))).go();
  }
}
