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
import 'package:suci/domain/enums/work_format.dart';
import 'package:suci/providers/database_provider.dart';
import 'package:suci/ui/library/reading_insights_sheet.dart';

void main() {
  group('Reading Insights & Header Micro-Interaction', () {
    testWidgets('Tapping Sūcī. wordmark opens Reading Insights sheet with metrics',
        (WidgetTester tester) async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final tagRepo = TagRepository(db);
      final logRepo = ProgressLogRepository(db);
      final workRepo = WorkRepository(db, tagRepo, logRepo);

      // Create a reading work and a completed work
      final workId = await workRepo.createWork(
        title: 'Lord of the Mysteries',
        author: 'Cuttlefish',
        status: ReadingStatus.reading.value,
        format: WorkFormat.webNovel.value,
        progressUnit: 'chapter',
        currentProgress: 50,
      );

      await workRepo.createWork(
        title: 'Three Body Problem',
        author: 'Liu Cixin',
        status: ReadingStatus.completed.value,
        format: WorkFormat.novel.value,
        progressUnit: 'page',
        currentProgress: 400,
        totalProgress: 400,
        completedAt: DateTime.now(),
      );

      // Add a log for today and yesterday to test streak calculation
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      await logRepo.addLog(
        workId: workId,
        progressUnit: 'chapter',
        progressValue: 48,
        recordedAt: yesterday,
      );

      await logRepo.addLog(
        workId: workId,
        progressUnit: 'chapter',
        progressValue: 50,
        recordedAt: now,
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

      // Find the pristine wordmark
      final titleFinder = find.byKey(const ValueKey('title_active'));
      expect(titleFinder, findsOneWidget);

      // Tap on Sūcī. wordmark
      await tester.tap(titleFinder);
      await tester.pumpAndSettle();

      // Verify Reading Insights sheet opens
      expect(find.byType(ReadingInsightsSheet), findsOneWidget);
      expect(find.text('Reading Insights'), findsOneWidget);

      // Verify active streak is 2 Days
      expect(find.text('2 Days'), findsOneWidget);
      expect(find.text('Active reading streak'), findsOneWidget);

      // Verify metrics
      expect(find.text('Currently Reading'), findsOneWidget);
      expect(find.text('Finished in ${now.year}'), findsOneWidget);

      // Close modal
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      await db.close();
    });
  });
}
