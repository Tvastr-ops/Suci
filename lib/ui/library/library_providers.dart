import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/models/work_item.dart';
import '../../providers/database_provider.dart';

class LibraryFilterState {
  final ReadingStatus? status;
  final String? searchQuery;
  final String? format;
  final String? tagFilter;
  final String sortBy;

  const LibraryFilterState({
    this.status = ReadingStatus.reading,
    this.searchQuery,
    this.format,
    this.tagFilter,
    this.sortBy = 'last_read',
  });

  bool get hasActiveExtraFilters =>
      (format != null && format != 'all') ||
      (tagFilter != null && tagFilter!.isNotEmpty) ||
      sortBy != 'last_read';

  LibraryFilterState copyWith({
    ReadingStatus? Function()? status,
    String? Function()? searchQuery,
    String? Function()? format,
    String? Function()? tagFilter,
    String? sortBy,
  }) {
    return LibraryFilterState(
      status: status != null ? status() : this.status,
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
      format: format != null ? format() : this.format,
      tagFilter: tagFilter != null ? tagFilter() : this.tagFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class LibraryFilterNotifier extends Notifier<LibraryFilterState> {
  @override
  LibraryFilterState build() => const LibraryFilterState();

  void setStatus(ReadingStatus? status) {
    state = state.copyWith(status: () => status);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: () => query);
  }

  void setFormat(String? format) {
    state = state.copyWith(format: () => format);
  }

  void setTagFilter(String? tag) {
    state = state.copyWith(tagFilter: () => tag);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void clearExtraFilters() {
    state = state.copyWith(
      format: () => null,
      tagFilter: () => null,
      sortBy: 'last_read',
      searchQuery: () => null,
    );
  }
}

final libraryFilterProvider =
    NotifierProvider<LibraryFilterNotifier, LibraryFilterState>(
        LibraryFilterNotifier.new);

final libraryWorksStreamProvider = StreamProvider<List<WorkItem>>((ref) {
  final filter = ref.watch(libraryFilterProvider);
  final repo = ref.watch(workRepositoryProvider);

  return repo.watchWorkItems(
    status: filter.status,
    searchQuery: filter.searchQuery,
    format: filter.format,
    tagFilter: filter.tagFilter,
    sortBy: filter.sortBy,
  );
});

final statusCountsStreamProvider = StreamProvider<Map<String, int>>((ref) {
  final repo = ref.watch(workRepositoryProvider);
  return repo.watchStatusCounts();
});

class ReadingInsightsData {
  final int streakDays;
  final int totalActiveDays;
  final int readingCount;
  final int completedThisYear;
  final int completedTotal;
  final int totalWorks;
  final int totalLogs;
  final Map<String, int> formatCounts;

  const ReadingInsightsData({
    required this.streakDays,
    required this.totalActiveDays,
    required this.readingCount,
    required this.completedThisYear,
    required this.completedTotal,
    required this.totalWorks,
    required this.totalLogs,
    required this.formatCounts,
  });

  static ReadingInsightsData empty() => const ReadingInsightsData(
        streakDays: 0,
        totalActiveDays: 0,
        readingCount: 0,
        completedThisYear: 0,
        completedTotal: 0,
        totalWorks: 0,
        totalLogs: 0,
        formatCounts: {},
      );
}

final allWorksStreamProvider = StreamProvider<List<Work>>((ref) {
  return ref.watch(workRepositoryProvider).watchAllWorks();
});

final allLogsStreamProvider = StreamProvider<List<ProgressLog>>((ref) {
  return ref.watch(progressLogRepositoryProvider).watchAllLogs();
});

final readingInsightsProvider = Provider<ReadingInsightsData>((ref) {
  final works = ref.watch(allWorksStreamProvider).value ?? [];
  final logs = ref.watch(allLogsStreamProvider).value ?? [];
  return _computeInsights(works, logs);
});

ReadingInsightsData _computeInsights(List<Work> works, List<ProgressLog> logs) {
  if (works.isEmpty && logs.isEmpty) {
    return ReadingInsightsData.empty();
  }

  final uniqueDays = <DateTime>{};
  for (final l in logs) {
    final d = l.recordedAt;
    uniqueDays.add(DateTime(d.year, d.month, d.day));
  }

  int streak = 0;
  if (uniqueDays.isNotEmpty) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    DateTime expectedDay;
    if (uniqueDays.contains(today)) {
      expectedDay = today;
    } else if (uniqueDays.contains(yesterday)) {
      expectedDay = yesterday;
    } else {
      expectedDay = DateTime(1970);
    }

    if (expectedDay.year > 1970) {
      final sortedDays = uniqueDays.toList()..sort((a, b) => b.compareTo(a));
      for (final day in sortedDays) {
        if (day == expectedDay) {
          streak++;
          expectedDay = expectedDay.subtract(const Duration(days: 1));
        } else if (day.isBefore(expectedDay)) {
          break;
        }
      }
    }
  }

  int readingCount = 0;
  int completedThisYear = 0;
  int completedTotal = 0;
  final currentYear = DateTime.now().year;
  final formatCounts = <String, int>{};

  for (final w in works) {
    if (w.status == ReadingStatus.reading.value) {
      readingCount++;
    } else if (w.status == ReadingStatus.completed.value) {
      completedTotal++;
      if (w.completedAt?.year == currentYear ||
          (w.completedAt == null && w.updatedAt.year == currentYear)) {
        completedThisYear++;
      }
    }
    formatCounts[w.format] = (formatCounts[w.format] ?? 0) + 1;
  }

  return ReadingInsightsData(
    streakDays: streak,
    totalActiveDays: uniqueDays.length,
    readingCount: readingCount,
    completedThisYear: completedThisYear,
    completedTotal: completedTotal,
    totalWorks: works.length,
    totalLogs: logs.length,
    formatCounts: formatCounts,
  );
}
