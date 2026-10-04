import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logging/app_logger.dart';
import '../../data/repositories/progress_log_repository.dart';
import '../../data/repositories/work_repository.dart';
import '../../domain/models/progress_log_entry.dart';
import '../../domain/models/work_item.dart';
import '../../providers/database_provider.dart';

final workDetailViewModelProvider =
    Provider.family<WorkDetailViewModel, String>((ref, workId) {
  final workRepo = ref.watch(workRepositoryProvider);
  final logRepo = ref.watch(progressLogRepositoryProvider);
  return WorkDetailViewModel(
    workRepo: workRepo,
    logRepo: logRepo,
    workId: workId,
  );
});

/// ViewModel managing presentation logic and actions for the WorkDetailScreen.
class WorkDetailViewModel {
  final WorkRepository workRepo;
  final ProgressLogRepository logRepo;
  final String workId;

  WorkDetailViewModel({
    required this.workRepo,
    required this.logRepo,
    required this.workId,
  });

  Stream<WorkItem?> watchWork() => workRepo.watchWorkItem(workId);

  Stream<List<ProgressLogEntry>> watchLogs() =>
      logRepo.watchLogEntriesForWork(workId);

  Future<void> updateRating(WorkItem work, int? newRating) async {
    try {
      await workRepo.updateWork(
        id: work.id,
        title: work.title,
        author: work.author,
        sourceUrl: work.sourceUrl,
        additionalUrlsJson: work.additionalUrls.isNotEmpty
            ? '[${work.additionalUrls.map((u) => '"$u"').join(',')}]'
            : '[]',
        format: work.format,
        status: work.status,
        publicationStatus: work.publicationStatus,
        coverPath: work.coverPath,
        progressUnit: work.progressUnit,
        currentProgress: work.currentProgress,
        totalProgress: work.totalProgress,
        currentVolume: work.currentVolume,
        totalVolumes: work.totalVolumes,
        rating: newRating,
        notes: work.notes,
        synopsis: work.synopsis,
        startedAt: work.startedAt,
        completedAt: work.completedAt,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to update rating', 'WorkDetailVM', e, stack);
      rethrow;
    }
  }

  Future<void> updateStatus(WorkItem work, String newStatus) async {
    try {
      final now = DateTime.now();
      DateTime? startedAt = work.startedAt;
      DateTime? completedAt = work.completedAt;

      if (newStatus == 'reading' && startedAt == null) {
        startedAt = now;
      }
      if (newStatus == 'completed' && completedAt == null) {
        completedAt = now;
      }

      await workRepo.updateWork(
        id: work.id,
        title: work.title,
        author: work.author,
        sourceUrl: work.sourceUrl,
        additionalUrlsJson: work.additionalUrls.isNotEmpty
            ? '[${work.additionalUrls.map((u) => '"$u"').join(',')}]'
            : '[]',
        format: work.format,
        status: newStatus,
        publicationStatus: work.publicationStatus,
        coverPath: work.coverPath,
        progressUnit: work.progressUnit,
        currentProgress: work.currentProgress,
        totalProgress: work.totalProgress,
        currentVolume: work.currentVolume,
        totalVolumes: work.totalVolumes,
        rating: work.rating,
        notes: work.notes,
        synopsis: work.synopsis,
        startedAt: startedAt,
        completedAt: completedAt,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to update status', 'WorkDetailVM', e, stack);
      rethrow;
    }
  }

  Future<void> updateDates(
    WorkItem work, {
    DateTime? startedAt,
    bool clearStartedAt = false,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) async {
    try {
      await workRepo.updateWork(
        id: work.id,
        title: work.title,
        author: work.author,
        sourceUrl: work.sourceUrl,
        additionalUrlsJson: work.additionalUrls.isNotEmpty
            ? '[${work.additionalUrls.map((u) => '"$u"').join(',')}]'
            : '[]',
        format: work.format,
        status: work.status,
        publicationStatus: work.publicationStatus,
        coverPath: work.coverPath,
        progressUnit: work.progressUnit,
        currentProgress: work.currentProgress,
        totalProgress: work.totalProgress,
        currentVolume: work.currentVolume,
        totalVolumes: work.totalVolumes,
        rating: work.rating,
        notes: work.notes,
        synopsis: work.synopsis,
        startedAt: startedAt ?? work.startedAt,
        clearStartedAt: clearStartedAt,
        completedAt: completedAt ?? work.completedAt,
        clearCompletedAt: clearCompletedAt,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to update dates', 'WorkDetailVM', e, stack);
      rethrow;
    }
  }

  Future<void> saveNotes(WorkItem work, String notes) async {
    try {
      await workRepo.updateWork(
        id: work.id,
        title: work.title,
        author: work.author,
        sourceUrl: work.sourceUrl,
        additionalUrlsJson: work.additionalUrls.isNotEmpty
            ? '[${work.additionalUrls.map((u) => '"$u"').join(',')}]'
            : '[]',
        format: work.format,
        status: work.status,
        publicationStatus: work.publicationStatus,
        coverPath: work.coverPath,
        progressUnit: work.progressUnit,
        currentProgress: work.currentProgress,
        totalProgress: work.totalProgress,
        currentVolume: work.currentVolume,
        totalVolumes: work.totalVolumes,
        rating: work.rating,
        notes: notes.trim().isEmpty ? null : notes.trim(),
        synopsis: work.synopsis,
        startedAt: work.startedAt,
        completedAt: work.completedAt,
      );
    } catch (e, stack) {
      AppLogger.error('Failed to save notes', 'WorkDetailVM', e, stack);
      rethrow;
    }
  }

  Future<void> increment() => workRepo.incrementProgress(workId);

  Future<void> decrement() => workRepo.decrementProgress(workId);

  Future<void> setProgressDirect(int value, {int? volumeValue}) =>
      workRepo.updateProgressDirect(
        workId: workId,
        progressValue: value,
        volumeValue: volumeValue,
      );

  Future<void> setTotalProgress(int? total, {int? totalVolumes}) =>
      workRepo.updateTotalProgress(
        workId: workId,
        totalProgress: total,
        totalVolumes: totalVolumes,
      );

  Future<void> setTotalVolumes(int? totalVolumes) =>
      workRepo.updateTotalVolumes(
        workId: workId,
        totalVolumes: totalVolumes,
      );

  Future<void> updateLog({
    required String logId,
    int? progressValue,
    int? volumeValue,
    String? note,
  }) =>
      logRepo.updateLog(
        id: logId,
        progressValue: progressValue,
        volumeValue: volumeValue,
        note: note,
      );

  Future<void> deleteLog(String logId) => logRepo.deleteLog(logId);

  Future<void> deleteWork() => workRepo.deleteWork(workId);
}
