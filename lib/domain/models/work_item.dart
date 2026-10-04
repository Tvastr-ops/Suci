import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../data/database/app_database.dart';
import '../enums/progress_unit.dart';
import '../enums/publication_status.dart';
import '../enums/reading_status.dart';
import '../enums/work_format.dart';

@immutable
class WorkItem {
  final String id;
  final String title;
  final String? author;
  final String? sourceUrl;
  final List<String> additionalUrls;
  final String format;
  final String status;
  final String publicationStatus;
  final String? coverPath;
  final String progressUnit;
  final int currentProgress;
  final int? totalProgress;
  final int? currentVolume;
  final int? totalVolumes;
  final int? rating;
  final String? notes;
  final String? synopsis;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastReadAt;

  const WorkItem({
    required this.id,
    required this.title,
    this.author,
    this.sourceUrl,
    this.additionalUrls = const [],
    required this.format,
    required this.status,
    required this.publicationStatus,
    this.coverPath,
    required this.progressUnit,
    required this.currentProgress,
    this.totalProgress,
    this.currentVolume,
    this.totalVolumes,
    this.rating,
    this.notes,
    this.synopsis,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
    this.lastReadAt,
  });

  /// True if explicitly marked as Completed or reached maximum available progress.
  bool get isCompleted =>
      status == ReadingStatus.completed.value ||
      (totalProgress != null && currentProgress >= totalProgress!);

  /// Progress fraction clamped to [0.0, 1.0], or null if total progress is unknown.
  double? get progressPercent {
    if (unit == ProgressUnit.percent) {
      return (currentProgress / 100.0).clamp(0.0, 1.0);
    }
    if (totalProgress != null && totalProgress! > 0) {
      return (currentProgress / totalProgress!).clamp(0.0, 1.0);
    }
    return null;
  }

  WorkFormat get workFormat => WorkFormat.fromValue(format);
  PublicationStatus get pubStatus => PublicationStatus.fromValue(publicationStatus);
  ReadingStatus get readStatus => ReadingStatus.fromValue(status);
  ProgressUnit get unit => ProgressUnit.fromValue(progressUnit);

  /// Human-readable progress string, e.g. "Ch. 45 / 100", "Vol. 3 / 15", or "Vol. 2, Ch. 12".
  String get formattedProgress {
    if (unit == ProgressUnit.volumeChapter) {
      final volPart = currentVolume != null ? 'Vol. $currentVolume' : '';
      final chPart = totalProgress != null && totalProgress! > 0
          ? 'Ch. $currentProgress / $totalProgress'
          : 'Ch. $currentProgress';
      if (volPart.isNotEmpty) {
        return '$volPart, $chPart';
      }
      return chPart;
    }

    final unitPrefix = unit == ProgressUnit.volume
        ? 'Vol.'
        : unit.label.startsWith('Ch')
            ? 'Ch.'
            : unit.label.startsWith('Pg')
                ? 'Pg.'
                : unit.label;

    final volPart = currentVolume != null && unit != ProgressUnit.volume
        ? 'Vol. $currentVolume, '
        : '';

    if (totalProgress != null && totalProgress! > 0) {
      return '$volPart$unitPrefix $currentProgress / $totalProgress';
    }
    return '$volPart$unitPrefix $currentProgress';
  }

  factory WorkItem.fromDrift(Work work, [List<String> tags = const []]) {
    List<String> urls = const [];
    try {
      final decoded = jsonDecode(work.additionalUrls);
      if (decoded is List) {
        urls = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return WorkItem(
      id: work.id,
      title: work.title,
      author: work.author,
      sourceUrl: work.sourceUrl,
      additionalUrls: List.unmodifiable(urls),
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
      tags: List.unmodifiable(tags),
      createdAt: work.createdAt,
      updatedAt: work.updatedAt,
      startedAt: work.startedAt,
      completedAt: work.completedAt,
      lastReadAt: work.lastReadAt,
    );
  }

  WorkItem copyWith({
    String? id,
    String? title,
    String? author,
    String? sourceUrl,
    List<String>? additionalUrls,
    String? format,
    String? status,
    String? publicationStatus,
    String? coverPath,
    String? progressUnit,
    int? currentProgress,
    int? totalProgress,
    bool clearTotalProgress = false,
    int? currentVolume,
    bool clearCurrentVolume = false,
    int? totalVolumes,
    bool clearTotalVolumes = false,
    int? rating,
    bool clearRating = false,
    String? notes,
    bool clearNotes = false,
    String? synopsis,
    bool clearSynopsis = false,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    bool clearStartedAt = false,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? lastReadAt,
    bool clearLastReadAt = false,
  }) {
    return WorkItem(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      additionalUrls: additionalUrls ?? this.additionalUrls,
      format: format ?? this.format,
      status: status ?? this.status,
      publicationStatus: publicationStatus ?? this.publicationStatus,
      coverPath: coverPath ?? this.coverPath,
      progressUnit: progressUnit ?? this.progressUnit,
      currentProgress: currentProgress ?? this.currentProgress,
      totalProgress: clearTotalProgress ? null : (totalProgress ?? this.totalProgress),
      currentVolume: clearCurrentVolume ? null : (currentVolume ?? this.currentVolume),
      totalVolumes: clearTotalVolumes ? null : (totalVolumes ?? this.totalVolumes),
      rating: clearRating ? null : (rating ?? this.rating),
      notes: clearNotes ? null : (notes ?? this.notes),
      synopsis: clearSynopsis ? null : (synopsis ?? this.synopsis),
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      lastReadAt: clearLastReadAt ? null : (lastReadAt ?? this.lastReadAt),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          author == other.author &&
          sourceUrl == other.sourceUrl &&
          listEquals(additionalUrls, other.additionalUrls) &&
          format == other.format &&
          status == other.status &&
          publicationStatus == other.publicationStatus &&
          coverPath == other.coverPath &&
          progressUnit == other.progressUnit &&
          currentProgress == other.currentProgress &&
          totalProgress == other.totalProgress &&
          currentVolume == other.currentVolume &&
          totalVolumes == other.totalVolumes &&
          rating == other.rating &&
          notes == other.notes &&
          synopsis == other.synopsis &&
          listEquals(tags, other.tags) &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          startedAt == other.startedAt &&
          completedAt == other.completedAt &&
          lastReadAt == other.lastReadAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      author.hashCode ^
      sourceUrl.hashCode ^
      additionalUrls.hashCode ^
      format.hashCode ^
      status.hashCode ^
      publicationStatus.hashCode ^
      coverPath.hashCode ^
      progressUnit.hashCode ^
      currentProgress.hashCode ^
      totalProgress.hashCode ^
      currentVolume.hashCode ^
      totalVolumes.hashCode ^
      rating.hashCode ^
      notes.hashCode ^
      synopsis.hashCode ^
      tags.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      startedAt.hashCode ^
      completedAt.hashCode ^
      lastReadAt.hashCode;

  @override
  String toString() =>
      'WorkItem(id: $id, title: $title, progress: $formattedProgress, status: $status)';
}
