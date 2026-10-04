import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_logger.dart';
import '../../core/result/result.dart';
import '../../data/repositories/work_repository.dart';
import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/publication_status.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/enums/work_format.dart';
import '../../domain/models/work_item.dart';
import '../../providers/database_provider.dart';

final addEditWorkViewModelProvider = Provider<AddEditWorkViewModel>((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return AddEditWorkViewModel(workRepo: repo);
});

class DomainSuggestion {
  final WorkFormat? suggestedFormat;
  final String? suggestedTag;

  const DomainSuggestion({this.suggestedFormat, this.suggestedTag});
}

class AddEditWorkViewModel {
  final WorkRepository workRepo;

  AddEditWorkViewModel({required this.workRepo});

  Future<WorkItem?> loadWork(String workId) async {
    try {
      return await workRepo.getWorkItem(workId);
    } catch (e, stack) {
      AppLogger.error('Failed to load work: $workId', 'AddEditWorkVM', e, stack);
      return null;
    }
  }

  DomainSuggestion detectDomain(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('royalroad.com')) {
      return const DomainSuggestion(
        suggestedFormat: WorkFormat.webNovel,
        suggestedTag: 'Royal Road',
      );
    } else if (lower.contains('archiveofourown.org')) {
      return const DomainSuggestion(
        suggestedFormat: WorkFormat.fanfiction,
        suggestedTag: 'AO3',
      );
    } else if (lower.contains('scribblehub.com')) {
      return const DomainSuggestion(
        suggestedFormat: WorkFormat.webNovel,
        suggestedTag: 'Scribble Hub',
      );
    } else if (lower.contains('fanfiction.net')) {
      return const DomainSuggestion(
        suggestedFormat: WorkFormat.fanfiction,
        suggestedTag: 'FFN',
      );
    } else if (lower.contains('spacebattles.com')) {
      return const DomainSuggestion(
        suggestedFormat: WorkFormat.webSerial,
        suggestedTag: 'Spacebattles',
      );
    }
    return const DomainSuggestion();
  }

  Future<Result<String>> saveWork({
    String? id,
    required String title,
    String? author,
    String? sourceUrl,
    List<String> additionalUrls = const [],
    required WorkFormat format,
    required ReadingStatus status,
    required PublicationStatus publicationStatus,
    String? coverPath,
    required ProgressUnit progressUnit,
    required int currentProgress,
    int? totalProgress,
    int? currentVolume,
    int? totalVolumes,
    int? rating,
    String? synopsis,
    String? notes,
    List<String> tags = const [],
    DateTime? startedAt,
    DateTime? completedAt,
  }) async {
    try {
      final additionalUrlsJson = jsonEncode(additionalUrls);

      if (id == null) {
        final newId = await workRepo.createWork(
          title: title,
          author: author,
          sourceUrl: sourceUrl,
          additionalUrlsJson: additionalUrlsJson,
          format: format.value,
          status: status.value,
          publicationStatus: publicationStatus.value,
          coverPath: coverPath,
          progressUnit: progressUnit.value,
          currentProgress: currentProgress,
          totalProgress: totalProgress,
          currentVolume: currentVolume,
          totalVolumes: totalVolumes,
          rating: rating,
          synopsis: synopsis,
          notes: notes,
          tags: tags,
          startedAt: startedAt,
          completedAt: completedAt,
        );
        return Result.ok(newId);
      } else {
        await workRepo.updateWork(
          id: id,
          title: title,
          author: author,
          sourceUrl: sourceUrl,
          additionalUrlsJson: additionalUrlsJson,
          format: format.value,
          status: status.value,
          publicationStatus: publicationStatus.value,
          coverPath: coverPath,
          progressUnit: progressUnit.value,
          currentProgress: currentProgress,
          totalProgress: totalProgress,
          currentVolume: currentVolume,
          totalVolumes: totalVolumes,
          rating: rating,
          synopsis: synopsis,
          notes: notes,
          tags: tags,
          startedAt: startedAt,
          clearStartedAt: startedAt == null,
          completedAt: completedAt,
          clearCompletedAt: completedAt == null,
        );
        return Result.ok(id);
      }
    } catch (e, stack) {
      AppLogger.error('Failed to save work', 'AddEditWorkVM', e, stack);
      return Result.err(e, stack);
    }
  }
}
