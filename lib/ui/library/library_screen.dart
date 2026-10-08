import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/enums/work_format.dart';
import '../shared/empty_state.dart';
import 'filter_bottom_sheet.dart';
import 'library_providers.dart';
import 'reading_insights_sheet.dart';
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
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _isSearching
              ? TextField(
                  key: const ValueKey('search_active'),
                  controller: _searchController,
                  autofocus: true,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Search title, author, tag...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
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
              : _SpringWordmark(
                  key: const ValueKey('title_active'),
                  onTap: () => showReadingInsightsSheet(context),
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

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;

                    if (isWide) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 4,
                          bottom: 88, // Space for FAB
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 520,
                          mainAxisExtent: 160,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: works.length,
                        itemBuilder: (context, index) {
                          final item = works[index];
                          return WorkCard(item: item);
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
        elevation: 1,
        highlightElevation: 3,
        onPressed: () => context.push('/work/add'),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(
          'Add Work',
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
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
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.82,
      ),
      builder: (ctx) => const FilterBottomSheet(),
    );
  }
}

class _SpringWordmark extends StatefulWidget {
  final VoidCallback onTap;

  const _SpringWordmark({super.key, required this.onTap});

  @override
  State<_SpringWordmark> createState() => _SpringWordmarkState();
}

class _SpringWordmarkState extends State<_SpringWordmark> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Text.rich(
          TextSpan(
            text: 'Sūcī',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
              color: theme.colorScheme.onSurface,
            ),
            children: [
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
