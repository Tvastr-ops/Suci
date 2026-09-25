import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/publication_status.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/enums/work_format.dart';
import '../../providers/database_provider.dart';
import '../shared/cover_fallback.dart';
import '../shared/star_rating.dart';
import 'progress_stepper.dart';

class WorkDetailScreen extends ConsumerStatefulWidget {
  final String workId;

  const WorkDetailScreen({super.key, required this.workId});

  @override
  ConsumerState<WorkDetailScreen> createState() => _WorkDetailScreenState();
}

class _WorkDetailScreenState extends ConsumerState<WorkDetailScreen> {
  bool _isEditingNotes = false;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final repo = ref.watch(workRepositoryProvider);
    final logRepo = ref.watch(progressLogRepositoryProvider);

    return StreamBuilder(
      stream: repo.watchWorkWithTags(widget.workId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final item = snapshot.data;
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Work not found')),
          );
        }

        final work = item.work;
        final tags = item.tags;
        final format = WorkFormat.fromValue(work.format);
        final pubStatus = PublicationStatus.fromValue(work.publicationStatus);
        final readingStatus = ReadingStatus.fromValue(work.status);
        final progressUnit = ProgressUnit.fromValue(work.progressUnit);

        List<String> additionalUrls = [];
        try {
          final decoded = jsonDecode(work.additionalUrls);
          if (decoded is List) {
            additionalUrls = decoded.cast<String>();
          }
        } catch (_) {}

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Work',
                onPressed: () => context.push('/work/edit/${work.id}'),
              ),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'delete') {
                    _confirmDelete(context, work.id, work.title);
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text('Delete Work',
                            style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // Top Header: Cover + Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CoverWidget(
                    title: work.title,
                    coverPath: work.coverPath,
                    width: 90,
                    height: 130,
                    borderRadius: 12,
                    showTitleInFallback: true,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          work.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        if (work.author != null &&
                            work.author!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'by ${work.author}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _buildChipBadge(context, format.label),
                            _buildChipBadge(context, pubStatus.label,
                                isMuted: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Interactive rating
                        StarRatingWidget(
                          rating: work.rating,
                          size: 24,
                          showNumber: true,
                          onRatingChanged: (newRating) {
                            repo.updateWork(
                              id: work.id,
                              title: work.title,
                              author: work.author,
                              sourceUrl: work.sourceUrl,
                              additionalUrlsJson: work.additionalUrls,
                              format: work.format,
                              status: work.status,
                              publicationStatus: work.publicationStatus,
                              coverPath: work.coverPath,
                              progressUnit: work.progressUnit,
                              currentProgress: work.currentProgress,
                              totalProgress: work.totalProgress,
                              currentVolume: work.currentVolume,
                              totalVolumes: work.totalVolumes,
                              rating: newRating,
                              notes: work.notes,
                              synopsis: work.synopsis,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Source URLs
              if (work.sourceUrl != null && work.sourceUrl!.isNotEmpty) ...[
                FilledButton.tonalIcon(
                  onPressed: () => _openUrl(context, work.sourceUrl!),
                  icon: const Icon(Icons.open_in_new_rounded, size: 18),
                  label: const Text('Open Primary Source'),
                ),
                const SizedBox(height: 8),
              ],

              if (additionalUrls.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: additionalUrls.map((url) {
                    final host = Uri.tryParse(url)?.host ?? 'Source';
                    return ActionChip(
                      avatar: const Icon(Icons.link_rounded, size: 16),
                      label: Text(host),
                      onPressed: () => _openUrl(context, url),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              const Divider(),
              const SizedBox(height: 8),

              // Shelf Status Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reading Status',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<ReadingStatus>(
                    value: readingStatus,
                    underline: const SizedBox(),
                    items: ReadingStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.label),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        repo.updateWork(
                          id: work.id,
                          title: work.title,
                          author: work.author,
                          sourceUrl: work.sourceUrl,
                          additionalUrlsJson: work.additionalUrls,
                          format: work.format,
                          status: newStatus.value,
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
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Interactive Progress Stepper
              ProgressStepperWidget(
                unit: progressUnit,
                currentProgress: work.currentProgress,
                totalProgress: work.totalProgress,
                currentVolume: work.currentVolume,
                totalVolumes: work.totalVolumes,
                onIncrement: () => repo.incrementProgress(work.id),
                onDecrement: () => repo.decrementProgress(work.id),
                onDirectProgressSet: (val) {
                  repo.updateProgressDirect(
                    workId: work.id,
                    progressValue: val,
                  );
                },
                onDirectVolumeSet: (vol) {
                  repo.updateProgressDirect(
                    workId: work.id,
                    progressValue: work.currentProgress,
                    volumeValue: vol,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Reading Dates Info
              _buildDatesRow(context, work),
              const SizedBox(height: 16),

              // Tags
              if (tags.isNotEmpty) ...[
                Text(
                  'Tags',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: tags.map((t) {
                    return Chip(
                      label: Text('#${t.name}'),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // Synopsis Section
              if (work.synopsis != null && work.synopsis!.isNotEmpty) ...[
                Text(
                  'Synopsis',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      work.synopsis!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Notes Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Personal Notes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(_isEditingNotes
                        ? Icons.check_rounded
                        : Icons.edit_note_rounded),
                    label: Text(_isEditingNotes ? 'Save' : 'Edit'),
                    onPressed: () {
                      if (_isEditingNotes) {
                        repo.updateWork(
                          id: work.id,
                          title: work.title,
                          author: work.author,
                          sourceUrl: work.sourceUrl,
                          additionalUrlsJson: work.additionalUrls,
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
                          notes: _notesController.text.trim(),
                          synopsis: work.synopsis,
                        );
                        setState(() {
                          _isEditingNotes = false;
                        });
                      } else {
                        _notesController.text = work.notes ?? '';
                        setState(() {
                          _isEditingNotes = true;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isEditingNotes)
                TextField(
                  controller: _notesController,
                  maxLines: 6,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Add impressions, arc notes, chapter bookmarks...',
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      work.notes?.isNotEmpty == true
                          ? work.notes!
                          : 'No notes yet. Tap Edit to add your thoughts.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: work.notes?.isNotEmpty == true
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                        fontStyle: work.notes?.isNotEmpty == true
                            ? FontStyle.normal
                            : FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Progress History Log
              Text(
                'Progress History',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StreamBuilder(
                stream: logRepo.watchLogsForWork(work.id),
                builder: (context, logSnapshot) {
                  final logs = logSnapshot.data ?? [];
                  if (logs.isEmpty) {
                    return Text(
                      'No history recorded yet.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    );
                  }

                  return Column(
                    children: logs.take(10).map((log) {
                      final dateStr = DateFormat('MMM d, y • h:mm a')
                          .format(log.recordedAt);
                      final unitLabel =
                          ProgressUnit.fromValue(log.progressUnit).label;

                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.bookmark_added_outlined,
                            size: 18),
                        title: Text(
                          '$unitLabel ${log.progressValue}${log.volumeValue != null ? ' (Vol ${log.volumeValue})' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          log.note != null && log.note!.isNotEmpty
                              ? '$dateStr — ${log.note}'
                              : dateStr,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChipBadge(BuildContext context, String text,
      {bool isMuted = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMuted
            ? colorScheme.surfaceContainerHighest
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isMuted
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDatesRow(BuildContext context, dynamic work) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, y');

    final startedAt = work.startedAt as DateTime?;
    final completedAt = work.completedAt as DateTime?;
    final lastReadAt = work.lastReadAt as DateTime?;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (startedAt != null)
          _buildDateItem(theme, 'Started', dateFormat.format(startedAt)),
        if (lastReadAt != null)
          _buildDateItem(theme, 'Last Read', dateFormat.format(lastReadAt)),
        if (completedAt != null)
          _buildDateItem(theme, 'Completed', dateFormat.format(completedAt)),
      ],
    );
  }

  Widget _buildDateItem(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            const SnackBar(content: Text('Could not open URL')),
          );
        }
      }
    }
  }

  void _confirmDelete(BuildContext context, String workId, String title) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Work?'),
          content: Text('Are you sure you want to delete "$title"?'),
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
                ref.read(workRepositoryProvider).deleteWork(workId);
                Navigator.pop(ctx);
                context.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
