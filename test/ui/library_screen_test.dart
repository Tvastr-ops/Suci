import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/app.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/data/repositories/progress_log_repository.dart';
import 'package:suci/data/repositories/tag_repository.dart';
import 'package:suci/data/repositories/work_repository.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/providers/database_provider.dart';
import 'package:suci/ui/library/status_chip_row.dart';

void main() {
  testWidgets('LibraryScreen displays empty state and renders works with reactive +1 updates',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

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

    // Initial pump
    await tester.pumpAndSettle();

    // Verify empty state is displayed
    expect(find.text('Your library is empty'), findsOneWidget);
    expect(find.text('Add First Work'), findsOneWidget);

    // Create a work in reading shelf
    await workRepo.createWork(
      title: 'Super Supportive',
      author: 'Sleyca',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 184,
      totalProgress: 200,
    );

    // Pump to reflect database stream update
    await tester.pumpAndSettle();

    // Verify work card renders
    expect(find.text('Super Supportive'), findsOneWidget);
    expect(find.text('by Sleyca'), findsOneWidget);
    expect(find.text('Ch. 184 / 200'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);

    // Tap +1 button
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    // Verify progress incremented reactively to 185
    expect(find.text('Ch. 185 / 200'), findsOneWidget);

    await db.close();
  });

  testWidgets('LibraryScreen status pills filter works dynamically and show counts',
      (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tagRepo = TagRepository(db);
    final logRepo = ProgressLogRepository(db);
    final workRepo = WorkRepository(db, tagRepo, logRepo);

    await workRepo.createWork(
      title: 'Super Supportive',
      author: 'Sleyca',
      status: ReadingStatus.reading.value,
      progressUnit: 'chapter',
      currentProgress: 184,
      totalProgress: 200,
    );

    await workRepo.createWork(
      title: 'Mother of Learning',
      author: 'nobody103',
      status: ReadingStatus.completed.value,
      progressUnit: 'chapter',
      currentProgress: 108,
      totalProgress: 108,
    );

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

    // Default shelf is Reading
    expect(find.text('Super Supportive'), findsOneWidget);
    expect(find.text('Mother of Learning'), findsNothing);

    // Tap 'All' status pill
    final allPill = find.descendant(
      of: find.byType(StatusChipRow),
      matching: find.text('All'),
    );
    await tester.tap(allPill);
    await tester.pumpAndSettle();

    // Both works visible on All shelf
    expect(find.text('Super Supportive'), findsOneWidget);
    expect(find.text('Mother of Learning'), findsOneWidget);

    // Scroll status chip row to reveal Completed pill
    await tester.drag(
      find.byType(StatusChipRow),
      const Offset(-200, 0),
    );
    await tester.pumpAndSettle();

    final completedPill = find.descendant(
      of: find.byType(StatusChipRow),
      matching: find.text('Completed'),
    );
    await tester.tap(completedPill);
    await tester.pumpAndSettle();

    // Only Completed work visible
    expect(find.text('Super Supportive'), findsNothing);
    expect(find.text('Mother of Learning'), findsOneWidget);

    await db.close();
  });
}



