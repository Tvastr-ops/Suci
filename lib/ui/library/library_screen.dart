import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/enums/work_format.dart';
import '../shared/empty_state.dart';
import 'filter_bottom_sheet.dart';
import 'library_providers.dart';
import 'status_chip_row.dart';
import 'work_card.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterState = ref.watch(libraryFilterProvider);
    final worksAsync = ref.watch(libraryWorksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search title, author, tag...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  ref
                      .read(libraryFilterProvider.notifier)
                      .setSearchQuery(val.isEmpty ? null : val);
                },
              )
            : Text(
                'Suci',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            tooltip: _isSearching ? 'Close Search' : 'Search',
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  ref
                      .read(libraryFilterProvider.notifier)
                      .setSearchQuery(null);
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: filterState.hasActiveExtraFilters,
              child: const Icon(Icons.tune_rounded),
            ),
            tooltip: 'Filter & Sort',
            onPressed: () => _openFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Shelf status tabs
          const StatusChipRow(),

          // Active extra filter chips bar
          if (filterState.hasActiveExtraFilters)
            _buildActiveFiltersBar(context, filterState),

          // Main list
          Expanded(
            child: worksAsync.when(
              data: (works) {
                if (works.isEmpty) {
                  final totalWorks =
                      ref.watch(statusCountsStreamProvider).value?['all'] ?? 0;

                  if (totalWorks == 0) {
                    return EmptyStateWidget.libraryEmpty(
                      onAddWork: () => context.push('/work/add'),
                    );
                  }

                  return EmptyStateWidget.noResults(
                    onClearFilters: () {
                      _searchController.clear();
                      ref
                          .read(libraryFilterProvider.notifier)
                          .clearExtraFilters();
                      ref
                          .read(libraryFilterProvider.notifier)
                          .setStatus(null);
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 88, // Space for FAB and bottom nav
                  ),
                  itemCount: works.length,
                  itemBuilder: (context, index) {
                    final item = works[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: WorkCard(item: item),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error loading works: $err'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/work/add'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Work'),
      ),
    );
  }

  Widget _buildActiveFiltersBar(
      BuildContext context, LibraryFilterState filterState) {
    final notifier = ref.read(libraryFilterProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (filterState.format != null && filterState.format != 'all')
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InputChip(
                  label: Text(
                      WorkFormat.fromValue(filterState.format!).label),
                  onDeleted: () => notifier.setFormat(null),
                ),
              ),
            if (filterState.tagFilter != null &&
                filterState.tagFilter!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InputChip(
                  label: Text('#${filterState.tagFilter!}'),
                  onDeleted: () => notifier.setTagFilter(null),
                ),
              ),
            if (filterState.sortBy != 'last_read')
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: InputChip(
                  label: Text(_formatSortLabel(filterState.sortBy)),
                  onDeleted: () => notifier.setSortBy('last_read'),
                ),
              ),
            TextButton(
              onPressed: () => notifier.clearExtraFilters(),
              child: const Text('Clear all', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSortLabel(String sortBy) {
    switch (sortBy) {
      case 'title':
        return 'Sorted: A-Z';
      case 'rating':
        return 'Sorted: Rating';
      case 'created':
        return 'Sorted: Date Added';
      default:
        return 'Sorted: Recent';
    }
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => const FilterBottomSheet(),
    );
  }
}
