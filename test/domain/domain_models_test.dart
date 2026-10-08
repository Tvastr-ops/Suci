import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/database/app_database.dart';
import 'package:suci/domain/enums/progress_unit.dart';
import 'package:suci/domain/enums/reading_status.dart';
import 'package:suci/domain/models/progress_log_entry.dart';
import 'package:suci/domain/models/tag_item.dart';
import 'package:suci/domain/models/work_item.dart';

void main() {
  group('WorkItem Domain Model', () {
    test('computes progressPercent, isCompleted, and formattedProgress accurately', () {
      final now = DateTime.now();
      final ongoingWork = WorkItem(
        id: '1',
        title: 'Lord of the Mysteries',
        format: 'web_novel',
        status: ReadingStatus.reading.value,
        publicationStatus: 'completed',
        progressUnit: 'chapter',
        currentProgress: 700,
        totalProgress: 1400,
        createdAt: now,
        updatedAt: now,
      );

      expect(ongoingWork.progressPercent, 0.5);
      expect(ongoingWork.isCompleted, isFalse);
      expect(ongoingWork.formattedProgress, 'Ch. 700 / 1400');

      final completedWork = ongoingWork.copyWith(
        currentProgress: 1400,
        status: ReadingStatus.completed.value,
      );

      expect(completedWork.progressPercent, 1.0);
      expect(completedWork.isCompleted, isTrue);

      final volumeWork = ongoingWork.copyWith(
        currentVolume: 3,
        currentProgress: 50,
        clearTotalProgress: true,
      );
      expect(volumeWork.formattedProgress, 'Vol. 3, Ch. 50');

      final pureVolumeWork = ongoingWork.copyWith(
        progressUnit: 'volume',
        currentProgress: 4,
        totalProgress: 12,
      );
      expect(pureVolumeWork.formattedProgress, 'Vol. 4 / 12');

      final pureVolumeNoTotal = pureVolumeWork.copyWith(
        clearTotalProgress: true,
      );
      expect(pureVolumeNoTotal.formattedProgress, 'Vol. 4');

      final volChWork = ongoingWork.copyWith(
        progressUnit: 'volume_chapter',
        currentVolume: 2,
        currentProgress: 15,
        totalProgress: 20,
      );
      expect(volChWork.formattedProgress, 'Vol. 2, Ch. 15 / 20');

      final pageWork = ongoingWork.copyWith(
        progressUnit: 'page',
        currentProgress: 120,
        totalProgress: 350,
      );
      expect(pageWork.formattedProgress, 'Pg. 120 / 350');

      final pageNoTotal = pageWork.copyWith(clearTotalProgress: true);
      expect(pageNoTotal.formattedProgress, 'Pg. 120');
      expect(pageNoTotal.unit, ProgressUnit.page);
    });

    test('ProgressUnit.fromValue maps page and pages correctly', () {
      expect(ProgressUnit.fromValue('page'), ProgressUnit.page);
      expect(ProgressUnit.fromValue('pages'), ProgressUnit.page);
      expect(ProgressUnit.fromValue('Pg'), ProgressUnit.page);
    });

    test('fromDrift maps Drift Work and tags correctly', () {
      final now = DateTime.now();
      final driftWork = Work(
        id: 'w1',
        title: 'Shadow Slave',
        additionalUrls: '["https://example.com/ch1", "https://example.com/ch2"]',
        format: 'web_novel',
        status: 'reading',
        publicationStatus: 'ongoing',
        progressUnit: 'chapter',
        currentProgress: 100,
        createdAt: now,
        updatedAt: now,
      );

      final domain = WorkItem.fromDrift(driftWork, ['Fantasy', 'Action']);

      expect(domain.id, 'w1');
      expect(domain.title, 'Shadow Slave');
      expect(domain.tags, ['Fantasy', 'Action']);
      expect(domain.additionalUrls, ['https://example.com/ch1', 'https://example.com/ch2']);
    });
  });

  group('ProgressLogEntry Domain Model', () {
    test('fromDrift maps Drift ProgressLog correctly', () {
      final now = DateTime.now();
      final driftLog = ProgressLog(
        id: 'log1',
        workId: 'w1',
        progressUnit: 'chapter',
        progressValue: 42,
        volumeValue: 2,
        note: 'Finished arc',
        recordedAt: now,
      );

      final entry = ProgressLogEntry.fromDrift(driftLog);

      expect(entry.id, 'log1');
      expect(entry.progressValue, 42);
      expect(entry.volumeValue, 2);
      expect(entry.note, 'Finished arc');
      expect(entry.recordedAt, now);
    });
  });

  group('TagItem Domain Model', () {
    test('fromDrift maps Drift Tag correctly', () {
      const driftTag = Tag(id: 't1', name: 'Cyberpunk');
      final tagItem = TagItem.fromDrift(driftTag);

      expect(tagItem.id, 't1');
      expect(tagItem.name, 'Cyberpunk');
      expect(tagItem, equals(const TagItem(id: 't1', name: 'Cyberpunk')));
    });
  });
}
