import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/work_repository.dart';
import '../../domain/enums/reading_status.dart';
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

final libraryWorksStreamProvider = StreamProvider<List<WorkWithTags>>((ref) {
  final filter = ref.watch(libraryFilterProvider);
  final repo = ref.watch(workRepositoryProvider);

  return repo.watchWorksWithTags(
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
