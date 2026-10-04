import 'package:flutter/foundation.dart';
import '../../data/database/app_database.dart';

@immutable
class ProgressLogEntry {
  final String id;
  final String workId;
  final String progressUnit;
  final int progressValue;
  final int? volumeValue;
  final String? note;
  final DateTime recordedAt;

  const ProgressLogEntry({
    required this.id,
    required this.workId,
    required this.progressUnit,
    required this.progressValue,
    this.volumeValue,
    this.note,
    required this.recordedAt,
  });

  factory ProgressLogEntry.fromDrift(ProgressLog log) {
    return ProgressLogEntry(
      id: log.id,
      workId: log.workId,
      progressUnit: log.progressUnit,
      progressValue: log.progressValue,
      volumeValue: log.volumeValue,
      note: log.note,
      recordedAt: log.recordedAt,
    );
  }

  ProgressLogEntry copyWith({
    String? id,
    String? workId,
    String? progressUnit,
    int? progressValue,
    int? volumeValue,
    String? note,
    DateTime? recordedAt,
  }) {
    return ProgressLogEntry(
      id: id ?? this.id,
      workId: workId ?? this.workId,
      progressUnit: progressUnit ?? this.progressUnit,
      progressValue: progressValue ?? this.progressValue,
      volumeValue: volumeValue ?? this.volumeValue,
      note: note ?? this.note,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressLogEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          workId == other.workId &&
          progressUnit == other.progressUnit &&
          progressValue == other.progressValue &&
          volumeValue == other.volumeValue &&
          note == other.note &&
          recordedAt == other.recordedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      workId.hashCode ^
      progressUnit.hashCode ^
      progressValue.hashCode ^
      volumeValue.hashCode ^
      note.hashCode ^
      recordedAt.hashCode;

  @override
  String toString() =>
      'ProgressLogEntry(id: $id, workId: $workId, unit: $progressUnit, value: $progressValue, vol: $volumeValue, at: $recordedAt)';
}
