import 'package:drift/native.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/providers/database_provider.dart';
import 'package:suci/ui/work_detail/work_detail_screen.dart';

void main() {
  testWidgets('WorkDetailScreen renders debounced session progress as x -> y (+delta)',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Create a work with initial progress at chapter 10
    final workId = await workRepo.createWork(
      title: 'Dungeon Crawler Carl',
      author: 'Matt Dinniman',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 10,
      totalProgress: 100,
    );

    // Simulate reading 3 chapters within a session: 10 -> 11 -> 12 -> 13
    await workRepo.incrementProgress(workId); // 11
    await workRepo.incrementProgress(workId); // 12
    await workRepo.incrementProgress(workId); // 13 (debounced into same session)

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: MaterialApp(
          home: WorkDetailScreen(workId: workId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial progress log entry at the bottom
    expect(find.text('Ch. 10'), findsOneWidget);

    // Verify consolidated session log displays as x -> y (+delta)
    expect(find.text('Ch. 10 → 13 (+3)'), findsOneWidget);

    await db.close();
  });

  testWidgets('WorkDetailScreen renders standalone volume progress correctly',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Create an LN tracked purely by volumes: Vol. 2 / 10
    final workId = await workRepo.createWork(
      title: 'Ascendance of a Bookworm',
      author: 'Miya Kazuki',
      status: ReadingStatus.reading.value,
      progressUnit: 'volume',
      currentProgress: 2,
      totalProgress: 10,
    );

    // Read to Volume 3
    await workRepo.incrementProgress(workId);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: MaterialApp(
          home: WorkDetailScreen(workId: workId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify stepper shows volume subtext
    expect(find.text('of 10 Volumes'), findsOneWidget);

    // Verify initial log shows Vol. 2
    expect(find.text('Vol. 2'), findsOneWidget);

    // Verify session log shows Vol. 2 -> 3 (+1)
    expect(find.text('Vol. 2 → 3 (+1)'), findsOneWidget);

    await db.close();
  });
}
