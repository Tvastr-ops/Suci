import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/work_repository.dart';
import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/publication_status.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/enums/work_format.dart';
import '../../providers/database_provider.dart';
import '../shared/cover_fallback.dart';
import '../shared/star_rating.dart';

class WorkCard extends ConsumerWidget {
  final WorkWithTags item;

  const WorkCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final work = item.work;

    final formatLabel = WorkFormat.fromValue(work.format).label;
    final pubStatusLabel =
        PublicationStatus.fromValue(work.publicationStatus).label;
    final progressString = _formatProgress(work);
    final progressPercent = _calculatePercentage(work);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/work/${work.id}'),
        onLongPress: () => _showQuickActionsSheet(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              CoverWidget(
                title: work.title,
                coverPath: work.coverPath,
                width: 60,
                height: 86,
                borderRadius: 8,
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      work.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Author
                    if (work.author != null && work.author!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'by ${work.author}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 6),

                    // Format and Publication Status Badges
                    Row(
                      children: [
                        _buildTinyBadge(context, formatLabel),
                        const SizedBox(width: 6),
                        _buildTinyBadge(context, pubStatusLabel, isMuted: true),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Progress text & optional progress bar
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            progressString,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        if (work.rating != null && work.rating! > 0)
                          StarRatingWidget(
                            rating: work.rating,
                            size: 14,
                            readOnly: true,
                            showNumber: true,
                          ),
                      ],
                    ),

                    if (progressPercent != null) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          minHeight: 4,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Right side action column
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1-tap +1 increment button
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      minimumSize: const Size(40, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(workRepositoryProvider)
                          .incrementProgress(work.id);
                    },
                    child: const Text(
                      '+1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Source URL link button if URL exists
                  if (work.sourceUrl != null && work.sourceUrl!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    IconButton(
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      color: colorScheme.onSurfaceVariant,
                      tooltip: 'Open Source',
                      onPressed: () => _openUrl(context, work.sourceUrl!),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTinyBadge(BuildContext context, String text,
      {bool isMuted = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMuted
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
            : colorScheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 10,
          color: isMuted
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  String _formatProgress(dynamic work) {
    final unit = ProgressUnit.fromValue(work.progressUnit);
    final current = work.currentProgress as int;
    final total = work.totalProgress as int?;
    final volume = work.currentVolume as int?;

    switch (unit) {
      case ProgressUnit.chapter:
        if (total != null) {
          return 'Ch. $current / $total';
        }
        return 'Ch. $current';

      case ProgressUnit.volumeChapter:
        final volStr = volume != null ? 'Vol. $volume, ' : '';
        if (total != null) {
          return '${volStr}Ch. $current / $total';
        }
        return '${volStr}Ch. $current';

      case ProgressUnit.words:
        final formatter = NumberFormat('#,###');
        final currentStr = formatter.format(current);
        if (total != null) {
          return '$currentStr / ${formatter.format(total)} words';
        }
        return '$currentStr words';

      case ProgressUnit.percent:
        return '$current%';
    }
  }

  double? _calculatePercentage(dynamic work) {
    final unit = ProgressUnit.fromValue(work.progressUnit);
    final current = work.currentProgress as int;
    final total = work.totalProgress as int?;

    if (unit == ProgressUnit.percent) {
      return (current / 100.0).clamp(0.0, 1.0);
    }

    if (total != null && total > 0) {
      return (current / total).clamp(0.0, 1.0);
    }

    return null;
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open source URL')),
          );
        }
      }
    }
  }

  void _showQuickActionsSheet(BuildContext context, WidgetRef ref) {
    final work = item.work;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Work'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/work/edit/${work.id}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.swap_horiz_rounded),
                title: const Text('Change Reading Status'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showStatusPicker(context, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent),
                title: const Text('Delete Work',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(context, ref);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showStatusPicker(BuildContext context, WidgetRef ref) {
    final work = item.work;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ReadingStatus.values.map((s) {
              return ListTile(
                title: Text(s.label),
                selected: work.status == s.value,
                trailing: work.status == s.value
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  ref.read(workRepositoryProvider).updateWork(
                        id: work.id,
                        title: work.title,
                        author: work.author,
                        sourceUrl: work.sourceUrl,
                        additionalUrlsJson: work.additionalUrls,
                        format: work.format,
                        status: s.value,
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
                      );
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final work = item.work;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Work?'),
          content: Text('Are you sure you want to delete "${work.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                ref.read(workRepositoryProvider).deleteWork(work.id);
                Navigator.pop(ctx);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
