import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/repositories/progress_log_repository.dart';
import '../data/repositories/tag_repository.dart';
import '../data/repositories/work_repository.dart';
import '../data/services/backup_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TagRepository(db);
});

final progressLogRepositoryProvider = Provider<ProgressLogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProgressLogRepository(db);
});

final workRepositoryProvider = Provider<WorkRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final tagRepo = ref.watch(tagRepositoryProvider);
  final logRepo = ref.watch(progressLogRepositoryProvider);
  return WorkRepository(db, tagRepo, logRepo);
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(databaseProvider);
  final tagRepo = ref.watch(tagRepositoryProvider);
  return BackupService(db, tagRepo);
});
