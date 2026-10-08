import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/models/progress_log_entry.dart';
import '../../domain/models/work_item.dart';
import '../shared/cover_fallback.dart';
import '../shared/star_rating.dart';
import 'progress_stepper.dart';
import 'work_detail_view_model.dart';

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
    final viewModel = ref.watch(workDetailViewModelProvider(widget.workId));

    return StreamBuilder<WorkItem?>(
      stream: viewModel.watchWork(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final work = snapshot.data;
        if (work == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Work not found')),
          );
        }

        final tags = work.tags;
        final format = work.workFormat;
        final pubStatus = work.pubStatus;
        final readingStatus = work.readStatus;
        final progressUnit = work.unit;
        final additionalUrls = work.additionalUrls;

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
                    _confirmDelete(context, viewModel, work.title);
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
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // Top Header: Cover + Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CoverWidget(
                      title: work.title,
                      coverPath: work.coverPath,
                      width: 96,
                      height: 140,
                      borderRadius: 12,
                      showTitleInFallback: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          work.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.25,
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
                          size: 22,
                          showNumber: true,
                          onRatingChanged: (newRating) {
                            viewModel.updateRating(work, newRating);
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showStatusPicker(context, viewModel, work),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer
                            .withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            readingStatus.label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.expand_more_rounded,
                            size: 18,
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Interactive Progress Stepper
              ProgressStepperWidget(
                unit: progressUnit,
                currentProgress: work.currentProgress,
                totalProgress: work.totalProgress,
                currentVolume: work.currentVolume,
                totalVolumes: work.totalVolumes,
                onIncrement: () => viewModel.increment(),
                onDecrement: () => viewModel.decrement(),
                onDirectProgressSet: (val) {
                  viewModel.setProgressDirect(val);
                },
                onDirectVolumeSet: (vol) {
                  viewModel.setProgressDirect(
                    work.currentProgress,
                    volumeValue: vol,
                  );
                },
                onDirectTotalSet: (total) {
                  viewModel.setTotalProgress(total);
                },
                onDirectTotalVolumesSet: (totalVols) {
                  viewModel.setTotalVolumes(totalVols);
                },
              ),
              const SizedBox(height: 16),

              // Reading Dates Info
              _buildDatesRow(context, viewModel, work),
              const SizedBox(height: 16),

              // Tags
              if (tags.isNotEmpty) ...[
                Text(
                  'Tags',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: tags.map((t) {
                    return Chip(
                      label: Text('#$t'),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      work.synopsis!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    icon: Icon(_isEditingNotes
                        ? Icons.check_rounded
                        : Icons.edit_note_rounded),
                    label: Text(_isEditingNotes ? 'Save' : 'Edit'),
                    onPressed: () async {
                      if (_isEditingNotes) {
                        await viewModel.saveNotes(
                          work,
                          _notesController.text,
                        );
                        if (context.mounted) {
                          setState(() {
                            _isEditingNotes = false;
                          });
                        }
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
                    padding: const EdgeInsets.all(14),
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
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Progress History Log
              Text(
                'Progress History',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<ProgressLogEntry>>(
                stream: viewModel.watchLogs(),
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

                  final displayLogs = logs.take(10).toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayLogs.length,
                    itemBuilder: (context, index) {
                      final log = displayLogs[index];
                      final dateStr = DateFormat('MMM d, y • h:mm a')
                          .format(log.recordedAt);
                      final isLast = index == displayLogs.length - 1;

                      final prevIndex = index + 1;
                      final prevLog = (prevIndex < logs.length &&
                              logs[prevIndex].progressUnit == log.progressUnit)
                          ? logs[prevIndex]
                          : null;
                      final progressDisplay = _formatLogProgress(log, prevLog);

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 1.5,
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => _showLogOptions(context, viewModel, log),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              progressDisplay,
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (log.volumeValue != null &&
                                                log.progressUnit !=
                                                    ProgressUnit.volume.value) ...[
                                              const SizedBox(width: 4),
                                              Text(
                                                '(Vol ${log.volumeValue})',
                                                style: theme.textTheme.labelSmall
                                                    ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ],
                                            const Spacer(),
                                            Text(
                                              dateStr,
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant
                                                    .withValues(alpha: 0.7),
                                                fontSize: 11,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.more_vert_rounded,
                                              size: 14,
                                              color: colorScheme
                                                  .onSurfaceVariant
                                                  .withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),
                                        if (log.note != null &&
                                            log.note!.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            log.note!,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  void _showStatusPicker(BuildContext context, WorkDetailViewModel viewModel, WorkItem work) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ReadingStatus.values.map((s) {
              final isSelected = work.readStatus == s;
              return ListTile(
                title: Text(s.label),
                selected: isSelected,
                trailing: isSelected ? const Icon(Icons.check_rounded) : null,
                onTap: () {
                  viewModel.updateStatus(work, s.value);
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isMuted
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
            : colorScheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
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

  String _formatLogProgress(ProgressLogEntry log, ProgressLogEntry? prevLog) {
    final unit = ProgressUnit.fromValue(log.progressUnit);
    final unitPrefix = unit == ProgressUnit.volume
        ? 'Vol.'
        : (unit.label.startsWith('Ch') || unit == ProgressUnit.volumeChapter)
            ? 'Ch.'
            : (unit == ProgressUnit.page || unit.label.startsWith('Pg'))
                ? 'Pg.'
                : unit.label;

    final current = log.progressValue;
    final prev = prevLog?.progressValue;

    if (prev != null && prev != current) {
      final delta = current - prev;
      final deltaSign = delta > 0 ? '+$delta' : '$delta';
      if (unit == ProgressUnit.percent) {
        return '$prev% → $current% ($deltaSign%)';
      } else if (unit == ProgressUnit.words) {
        final formatter = NumberFormat('#,###');
        return '${formatter.format(prev)} → ${formatter.format(current)} words ($deltaSign)';
      } else {
        return '$unitPrefix $prev → $current ($deltaSign)';
      }
    }

    if (unit == ProgressUnit.percent) {
      return '$current%';
    } else if (unit == ProgressUnit.words) {
      final formatter = NumberFormat('#,###');
      return '${formatter.format(current)} words';
    } else {
      return '$unitPrefix $current';
    }
  }

  Widget _buildDatesRow(BuildContext context, WorkDetailViewModel viewModel, WorkItem work) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, y');

    final startedAt = work.startedAt;
    final completedAt = work.completedAt;
    final lastReadAt = work.lastReadAt;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDateItem(
            theme,
            'Started',
            startedAt != null ? dateFormat.format(startedAt) : 'Set start date',
            hasValue: startedAt != null,
            onTap: () => _editDate(context, viewModel, work, isStarted: true),
          ),
          if (lastReadAt != null)
            _buildDateItem(
              theme,
              'Last Read',
              dateFormat.format(lastReadAt),
              hasValue: true,
            ),
          _buildDateItem(
            theme,
            'Completed',
            completedAt != null ? dateFormat.format(completedAt) : 'Set completed',
            hasValue: completedAt != null,
            onTap: () => _editDate(context, viewModel, work, isStarted: false),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(ThemeData theme, String label, String value,
      {bool hasValue = false, VoidCallback? onTap}) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.edit_outlined,
                  size: 11, color: theme.colorScheme.primary),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
            color: hasValue
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: content,
        ),
      );
    }

    return content;
  }

  Future<void> _editDate(
    BuildContext context,
    WorkDetailViewModel viewModel,
    WorkItem work, {
    required bool isStarted,
  }) async {
    final currentDate = isStarted ? work.startedAt : work.completedAt;

    if (currentDate != null) {
      final action = await showModalBottomSheet<String>(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today_rounded),
                title: const Text('Change Date'),
                onTap: () => Navigator.pop(ctx, 'change'),
              ),
              ListTile(
                leading:
                    const Icon(Icons.clear_rounded, color: Colors.redAccent),
                title: const Text('Clear Date',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () => Navigator.pop(ctx, 'clear'),
              ),
            ],
          ),
        ),
      );

      if (action == 'clear') {
        await viewModel.updateDates(
          work,
          clearStartedAt: isStarted,
          clearCompletedAt: !isStarted,
        );
        return;
      } else if (action != 'change') {
        return;
      }
      if (!context.mounted) return;
    }

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: DateTime(1970),
      lastDate: DateTime(now.year + 5),
      helpText: isStarted ? 'SELECT STARTED DATE' : 'SELECT COMPLETED DATE',
    );

    if (picked != null) {
      await viewModel.updateDates(
        work,
        startedAt: isStarted ? picked : null,
        completedAt: !isStarted ? picked : null,
      );
    }
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

  void _confirmDelete(BuildContext context, WorkDetailViewModel viewModel, String title) {
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
              onPressed: () async {
                await viewModel.deleteWork();
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) context.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showLogOptions(BuildContext context, WorkDetailViewModel viewModel, ProgressLogEntry log) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Log'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditLogDialog(context, viewModel, log);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.error,
                ),
                title: Text(
                  'Delete Log',
                  style: TextStyle(color: colorScheme.error),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDeleteLog(context, viewModel, log);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditLogDialog(
    BuildContext context,
    WorkDetailViewModel viewModel,
    ProgressLogEntry log,
  ) {
    final progressController =
        TextEditingController(text: log.progressValue.toString());
    final volumeController = TextEditingController(
        text: log.volumeValue != null ? log.volumeValue.toString() : '');
    final noteController = TextEditingController(text: log.note ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Progress Log'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: progressController,
                  decoration: InputDecoration(
                    labelText:
                        '${ProgressUnit.fromValue(log.progressUnit).label} Number',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: volumeController,
                  decoration: const InputDecoration(
                    labelText: 'Volume (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final newProgress =
                    int.tryParse(progressController.text.trim());
                if (newProgress == null) return;
                final newVolume = int.tryParse(volumeController.text.trim());
                final newNote = noteController.text.trim();

                await viewModel.updateLog(
                  logId: log.id,
                  progressValue: newProgress,
                  volumeValue: newVolume,
                  note: newNote.isEmpty ? null : newNote,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteLog(
    BuildContext context,
    WorkDetailViewModel viewModel,
    ProgressLogEntry log,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Log?'),
          content:
              const Text('Are you sure you want to delete this progress log?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                await viewModel.deleteLog(log.id);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Log deleted')),
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
