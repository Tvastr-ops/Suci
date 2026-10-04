import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/ui/work_detail/work_detail_view_model.dart';

void main() {
  late AppDatabase db;
  late TagRepository tagRepo;
  late ProgressLogRepository logRepo;
  late WorkRepository workRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tagRepo = TagRepository(db);
    logRepo = ProgressLogRepository(db);
    workRepo = WorkRepository(db, tagRepo, logRepo);
  });

  tearDown(() async {
    await db.close();
  });

  test('WorkDetailViewModel increments, updates rating, notes, and manages logs', () async {
    final workId = await workRepo.createWork(
      title: 'Cradle',
      author: 'Will Wight',
      status: ReadingStatus.reading.value,
      progressUnit: 'volume',
      currentProgress: 1,
      totalProgress: 12,
    );

    final vm = WorkDetailViewModel(
      workRepo: workRepo,
      logRepo: logRepo,
      workId: workId,
    );

    // Initial item
    final initial = await vm.watchWork().first;
    expect(initial, isNotNull);
    expect(initial!.title, 'Cradle');
    expect(initial.currentProgress, 1);

    // Increment
    await vm.increment();
    final updated = await vm.watchWork().first;
    expect(updated!.currentProgress, 2);

    // Update rating
    await vm.updateRating(updated, 10);
    final rated = await vm.watchWork().first;
    expect(rated!.rating, 10);

    // Save notes
    await vm.saveNotes(rated, 'Unsouled was fantastic!');
    final noted = await vm.watchWork().first;
    expect(noted!.notes, 'Unsouled was fantastic!');

    // Log management
    final logs = await vm.watchLogs().first;
    expect(logs, isNotEmpty);
    final logId = logs.first.id;

    await vm.updateLog(logId: logId, progressValue: 3, note: 'Read late at night');
    final updatedLogs = await vm.watchLogs().first;
    expect(updatedLogs.first.progressValue, 3);
    expect(updatedLogs.first.note, 'Read late at night');

    await vm.deleteLog(logId);
    final remainingLogs = await vm.watchLogs().first;
    expect(remainingLogs.length, 1);
    expect(remainingLogs.first.note, 'Initial progress');
  });
}
