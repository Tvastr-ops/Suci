import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/data/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late TagRepository tagRepo;
  late ProgressLogRepository logRepo;
  late WorkRepository workRepo;
  late BackupService backupService;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tagRepo = TagRepository(db);
    logRepo = ProgressLogRepository(db);
    workRepo = WorkRepository(db, tagRepo, logRepo);
    backupService = BackupService(db, tagRepo);
  });

  tearDown(() async {
    await db.close();
  });

  test('exportToJson and importBackup round-trip preserves all work data and tags', () async {
    final workId = await workRepo.createWork(
      id: 'test-work-1',
      title: 'A Practical Guide to Evil',
      author: 'ErraticErrata',
      sourceUrl: 'https://practicalguidetoevil.wordpress.com/',
      format: 'web_serial',
      status: 'completed',
      publicationStatus: 'completed',
      progressUnit: 'chapter',
      currentProgress: 350,
      totalProgress: 350,
      rating: 9,
      tags: ['Fantasy', 'Villain Protagonist', 'Web Serial'],
      notes: 'Outstanding worldbuilding.',
      synopsis: 'The story of Catherine Foundling.',
    );

    final exportedJson = await backupService.exportToJson();
    expect(exportedJson, contains('A Practical Guide to Evil'));
    expect(exportedJson, contains('ErraticErrata'));
    expect(exportedJson, contains('Villain Protagonist'));

    final preview = backupService.parseAndValidateJson(exportedJson);
    expect(preview.workCount, 1);
    expect(preview.tagCount, 3);
    expect(preview.version, 1);

    // Clear db
    await workRepo.clearAllData();
    expect(await workRepo.getWorkWithTags(workId), isNull);

    // Restore via overwrite
    await backupService.importBackup(preview.rawData, overwrite: true);

    final restored = await workRepo.getWorkWithTags(workId);
    expect(restored, isNotNull);
    expect(restored!.work.title, 'A Practical Guide to Evil');
    expect(restored.work.author, 'ErraticErrata');
    expect(restored.work.currentProgress, 350);
    expect(restored.tags.length, 3);
  });

  test('importBackup merge strategy follows last updated_at wins', () async {
    // 1. Create Work A locally at T1
    final t1 = DateTime(2026, 1, 1, 12, 0);
    final workId = await workRepo.createWork(
      id: 'conflict-work-1',
      title: 'Super Supportive',
      currentProgress: 100,
      createdAt: t1,
      updatedAt: t1,
    );

    // 2. Import backup with newer updatedAt (T2 > T1) and higher progress
    final t2 = DateTime(2026, 2, 1, 12, 0);
    final importPayload = {
      'suci_version': 1,
      'works': [
        {
          'id': workId,
          'title': 'Super Supportive (Updated)',
          'status': 'reading',
          'progress': {
            'unit': 'chapter',
            'current': 150,
            'total': null,
          },
          'tags': ['Superhero'],
          'created_at': t1.toIso8601String(),
          'updated_at': t2.toIso8601String(),
        },
        {
          'id': 'new-work-2',
          'title': 'Worm',
          'author': 'Wildbow',
          'status': 'completed',
          'progress': {
            'unit': 'chapter',
            'current': 304,
            'total': 304,
          },
          'tags': ['Parahuman'],
          'created_at': t2.toIso8601String(),
          'updated_at': t2.toIso8601String(),
        }
      ],
      'tags': [],
      'progress_logs': [],
    };

    await backupService.importBackup(importPayload, overwrite: false);

    // Work 1 should have been updated because T2 > T1
    final work1 = await workRepo.getWorkWithTags(workId);
    expect(work1!.work.title, 'Super Supportive (Updated)');
    expect(work1.work.currentProgress, 150);

    // Work 2 should have been added
    final work2 = await workRepo.getWorkWithTags('new-work-2');
    expect(work2, isNotNull);
    expect(work2!.work.title, 'Worm');
  });

  test('exportToCsv generates valid comma-separated rows with header', () async {
    await workRepo.createWork(
      title: 'The Wandering Inn',
      author: 'pirateaba',
      currentProgress: 1000,
      tags: ['Fantasy', 'LitRPG'],
    );

    final csv = await backupService.exportToCsv();
    expect(csv, contains('Title,Author,Status'));
    expect(csv, contains('The Wandering Inn,pirateaba'));
    expect(csv.contains('Fantasy') && csv.contains('LitRPG'), isTrue);
  });
}
