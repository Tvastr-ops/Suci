import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/app.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/providers/database_provider.dart';

void main() {
  testWidgets(
      'Adaptive navigation: renders NavigationBar on compact/phone screens (<600dp)',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: const SuciApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await db.close();
  });

  testWidgets(
      'Adaptive navigation: renders NavigationRail on wide/tablet screens (>=600dp)',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: const SuciApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await db.close();
  });

  testWidgets(
      'Adaptive library: uses ListView on phone screens and GridView on wide screens',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    await workRepo.createWork(
      title: 'A Journey of Black and Red',
      author: 'mecanimus',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 50,
      totalProgress: 215,
    );

    // Test on phone screen
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: const SuciApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(GridView), findsNothing);

    // Test on wide tablet screen
    tester.view.physicalSize = const Size(900, 600);
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await db.close();
  });

  testWidgets(
      'Settings screen: streamlined export option opens bottom sheet with all formats',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          tagRepositoryProvider.overrideWithValue(tagRepo),
          progressLogRepositoryProvider.overrideWithValue(logRepo),
          workRepositoryProvider.overrideWithValue(workRepo),
        ],
        child: const SuciApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Navigate to Settings
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Scroll down settings to find "Export Library" unified tile
    await tester.scrollUntilVisible(find.text('Export Library'), 200);
    await tester.pumpAndSettle();
    expect(find.text('Export Library'), findsOneWidget);
    await tester.tap(find.text('Export Library'));
    await tester.pumpAndSettle();

    // Verify modal bottom sheet opens with all 3 export options
    expect(find.text('JSON Backup'), findsOneWidget);
    expect(find.text('Full Archive (.ZIP)'), findsOneWidget);
    expect(find.text('Spreadsheet (.CSV)'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await db.close();
  });
}
