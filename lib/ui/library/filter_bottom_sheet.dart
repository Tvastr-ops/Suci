import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/work_format.dart';
import '../../providers/database_provider.dart';
import 'library_providers.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late String? _selectedFormat;
  late String? _selectedTag;
  late String _selectedSortBy;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(libraryFilterProvider);
    _selectedFormat = filter.format;
    _selectedTag = filter.tagFilter;
    _selectedSortBy = filter.sortBy;
  }

  bool _isTagsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tagRepo = ref.watch(tagRepositoryProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pinned Header: Title & Reset
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter & Sort',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFormat = null;
                      _selectedTag = null;
                      _selectedSortBy = 'last_read';
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Body
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort Section
                  Text(
                    'Sort By',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip('last_read', 'Recently Read'),
                      _buildSortChip('title', 'Title (A-Z)'),
                      _buildSortChip('rating', 'Highest Rated'),
                      _buildSortChip('created', 'Recently Added'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Format Section
                  Text(
                    'Medium / Format',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All Formats'),
                        selected:
                            _selectedFormat == null || _selectedFormat == 'all',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFormat = null;
                          });
                        },
                      ),
                      ...WorkFormat.values.map((f) {
                        final isSelected = _selectedFormat == f.value;
                        return FilterChip(
                          label: Text(f.label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFormat = selected ? f.value : null;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tags Section with Collapse/Expand
                  Text(
                    'Tags',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder(
                    future: tagRepo.getAllTags(),
                    builder: (context, snapshot) {
                      final tags = snapshot.data ?? [];
                      if (tags.isEmpty) {
                        return Text(
                          'No tags created yet.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      }

                      final hasCollapse = tags.length > 5;
                      final displayedTags = (hasCollapse && !_isTagsExpanded)
                          ? () {
                              final top5 = tags.take(5).toList();
                              if (_selectedTag != null &&
                                  !top5.any((t) => t.name == _selectedTag)) {
                                final sel =
                                    tags.where((t) => t.name == _selectedTag);
                                if (sel.isNotEmpty) {
                                  top5.add(sel.first);
                                }
                              }
                              return top5;
                            }()
                          : tags;

                      final remainingCount =
                          tags.length - displayedTags.length;

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...displayedTags.map((t) {
                            final isSelected = _selectedTag == t.name;
                            return FilterChip(
                              label: Text(t.name),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedTag = selected ? t.name : null;
                                });
                              },
                            );
                          }),
                          if (hasCollapse &&
                              !_isTagsExpanded &&
                              remainingCount > 0)
                            ActionChip(
                              avatar: const Icon(Icons.expand_more_rounded,
                                  size: 16),
                              label: Text('+$remainingCount more'),
                              onPressed: () {
                                setState(() {
                                  _isTagsExpanded = true;
                                });
                              },
                            )
                          else if (hasCollapse && _isTagsExpanded)
                            ActionChip(
                              avatar: const Icon(Icons.expand_less_rounded,
                                  size: 16),
                              label: const Text('Show less'),
                              onPressed: () {
                                setState(() {
                                  _isTagsExpanded = false;
                                });
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Pinned Footer: Apply Filters Button
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final notifier =
                      ref.read(libraryFilterProvider.notifier);
                  notifier.setFormat(_selectedFormat);
                  notifier.setTagFilter(_selectedTag);
                  notifier.setSortBy(_selectedSortBy);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    final isSelected = _selectedSortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedSortBy = value;
          });
        }
      },
    );
  }
}
