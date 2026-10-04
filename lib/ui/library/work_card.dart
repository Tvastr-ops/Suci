import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/models/work_item.dart';
import '../../providers/database_provider.dart';
import '../shared/cover_fallback.dart';

class WorkCard extends ConsumerWidget {
  final WorkItem item;

  const WorkCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final work = item;

    final formatLabel = work.workFormat.label;
    final pubStatusLabel = work.pubStatus.label;
    final progressString = work.formattedProgress;
    final progressPercent = work.progressPercent;

    final metaParts = <String>[];
    if (formatLabel.isNotEmpty) metaParts.add(formatLabel);
    if (pubStatusLabel.isNotEmpty) metaParts.add(pubStatusLabel);
    final metaLine = metaParts.join(' • ');

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
              // Cover with book-jacket depth shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CoverWidget(
                  title: work.title,
                  coverPath: work.coverPath,
                  width: 58,
                  height: 84,
                  borderRadius: 8,
                ),
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
                        fontWeight: FontWeight.w600,
                        height: 1.25,
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

                    if (metaLine.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        metaLine,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 6),

                    // Progress text & optional compact star rating
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    size: 13, color: colorScheme.primary),
                                const SizedBox(width: 2),
                                Text(
                                  (work.rating! / 2.0).toStringAsFixed(1),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    if (progressPercent != null) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(begin: 0, end: progressPercent),
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 3,
                              backgroundColor: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary),
                            );
                          },
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
                  if (work.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Done',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // 1-tap +1 increment button (long-press for custom amount)
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: const Size(42, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(workRepositoryProvider)
                            .incrementProgress(work.id);
                      },
                      onLongPress: () => _showQuickIncrementSheet(context, ref),
                      child: Text(
                        '+1',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSecondaryContainer,
                        ),
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
    final work = item;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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
    final work = item;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ReadingStatus.values.map((s) {
              return ListTile(
                title: Text(s.label),
                selected: work.readStatus == s,
                trailing: work.readStatus == s
                    ? const Icon(Icons.check_rounded)
                    : null,
                onTap: () {
                  ref.read(workRepositoryProvider).updateWork(
                        id: work.id,
                        title: work.title,
                        author: work.author,
                        sourceUrl: work.sourceUrl,
                        additionalUrlsJson: work.additionalUrls.isNotEmpty
                            ? '[${work.additionalUrls.map((u) => '"$u"').join(',')}]'
                            : '[]',
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
    final work = item;
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

  void _showQuickIncrementSheet(BuildContext context, WidgetRef ref) {
    final work = item;
    final unit = work.unit;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = TextEditingController();

    final List<int> increments;
    switch (unit) {
      case ProgressUnit.volume:
        increments = [1, 2, 3, 5];
        break;
      case ProgressUnit.chapter:
      case ProgressUnit.volumeChapter:
        increments = [2, 5, 10, 25];
        break;
      case ProgressUnit.percent:
        increments = [5, 10, 25, 50];
        break;
      case ProgressUnit.words:
        increments = [1000, 2500, 5000, 10000];
        break;
    }

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 4,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Progress Update',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${work.title} • Current: ${work.formattedProgress}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Text(
                'Quick Add',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: increments.map((inc) {
                  final label = unit == ProgressUnit.words
                      ? '+${NumberFormat.compact().format(inc)}'
                      : unit == ProgressUnit.percent
                          ? '+$inc%'
                          : '+$inc';
                  return ActionChip(
                    label: Text(label,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ref
                          .read(workRepositoryProvider)
                          .incrementProgress(work.id, amount: inc);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $label to "${work.title}"'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Or Set Directly',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter new ${unit.label.toLowerCase()}',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final val = int.tryParse(controller.text.trim());
                      if (val != null) {
                        ref
                            .read(workRepositoryProvider)
                            .updateProgressDirect(
                              workId: work.id,
                              progressValue: val,
                            );
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Updated "${work.title}" to $val ${unit.label}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text('Set'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
