import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/reading_status.dart';

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

  test('createWork and getWorkWithTags returns work with tags', () async {
    final workId = await workRepo.createWork(
      title: 'Super Supportive',
      author: 'Sleyca',
      sourceUrl: 'https://www.royalroad.com/fiction/63759/super-supportive',
      format: 'web_novel',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 184,
      totalProgress: null,
      rating: 10,
      tags: ['LitRPG', 'Superhero'],
    );

    final workData = await workRepo.getWorkWithTags(workId);
    expect(workData, isNotNull);
    expect(workData!.work.title, 'Super Supportive');
    expect(workData.work.author, 'Sleyca');
    expect(workData.work.currentProgress, 184);
    expect(workData.work.rating, 10);
    expect(workData.work.startedAt, isNotNull); // Auto-set for reading
    expect(workData.tags.map((t) => t.name).toList(), containsAll(['LitRPG', 'Superhero']));

    // Verify initial progress log was recorded
    final logs = await logRepo.getLogsForWork(workId);
    expect(logs.length, 1);
    expect(logs.first.progressUnit, 'chapter');
    expect(logs.first.progressValue, 184);
  });

  test('incrementProgress increments chapter, sets lastReadAt, and records log', () async {
    final workId = await workRepo.createWork(
      title: 'Trailblazer',
      author: '3ndless',
      status: ReadingStatus.planToRead.value,
      progressUnit: 'chapter',
      currentProgress: 0,
      totalProgress: 120,
    );

    // Initial state: plan_to_read, startedAt is null
    var workData = await workRepo.getWorkWithTags(workId);
    expect(workData!.work.status, ReadingStatus.planToRead.value);
    expect(workData.work.startedAt, isNull);

    // Increment progress
    await workRepo.incrementProgress(workId);

    workData = await workRepo.getWorkWithTags(workId);
    expect(workData!.work.currentProgress, 1);
    expect(workData.work.lastReadAt, isNotNull);
    // Transition to reading automatically sets startedAt
    expect(workData.work.status, ReadingStatus.reading.value);
    expect(workData.work.startedAt, isNotNull);

    // Check progress log
    final logs = await logRepo.getLogsForWork(workId);
    expect(logs.length, 1);
    expect(logs.first.progressValue, 1);
    expect(logs.first.progressUnit, 'chapter');
  });

  test('changing progress unit retains historical snapshot in logs', () async {
    final workId = await workRepo.createWork(
      title: 'Mother of Learning',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 50,
    );

    // Now update work to percent tracking
    await workRepo.updateWork(
      id: workId,
      title: 'Mother of Learning',
      format: 'web_novel',
      status: ReadingStatus.reading.value,
      publicationStatus: 'completed',
      progressUnit: 'percent',
      currentProgress: 75,
    );

    final logs = await logRepo.getLogsForWork(workId);
    expect(logs.length, 2);
    // Old log should still record 'chapter'
    expect(logs.any((l) => l.progressUnit == 'chapter' && l.progressValue == 50), isTrue);
    // New log should record 'percent'
    expect(logs.any((l) => l.progressUnit == 'percent' && l.progressValue == 75), isTrue);
  });

  test('deleteWork cascades to work_tags and progress_logs', () async {
    final workId = await workRepo.createWork(
      title: 'Temporary Work',
      status: ReadingStatus.reading.value,
      currentProgress: 10,
      tags: ['TempTag'],
    );

    expect(await workRepo.getWorkWithTags(workId), isNotNull);
    expect((await logRepo.getLogsForWork(workId)).length, 1);

    await workRepo.deleteWork(workId);

    expect(await workRepo.getWorkWithTags(workId), isNull);
    expect((await logRepo.getLogsForWork(workId)).isEmpty, isTrue);
  });
}
