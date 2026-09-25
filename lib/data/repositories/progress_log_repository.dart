import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class ProgressLogRepository {
  final AppDatabase _db;
  final Uuid _uuid;

  ProgressLogRepository(this._db, [Uuid? uuid]) : _uuid = uuid ?? const Uuid();

  Stream<List<ProgressLog>> watchLogsForWork(String workId) {
    return (_db.select(_db.progressLogs)
          ..where((l) => l.workId.equals(workId))
          ..orderBy([(l) => OrderingTerm.desc(l.recordedAt)]))
        .watch();
  }

  Future<List<ProgressLog>> getLogsForWork(String workId, {int? limit}) {
    final query = (_db.select(_db.progressLogs)
      ..where((l) => l.workId.equals(workId))
      ..orderBy([(l) => OrderingTerm.desc(l.recordedAt)]));

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
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

  Future<void> deleteLog(String id) {
    return (_db.delete(_db.progressLogs)..where((l) => l.id.equals(id))).go();
  }
}
