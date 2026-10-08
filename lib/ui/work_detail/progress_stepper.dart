import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/enums/progress_unit.dart';

class ProgressStepperWidget extends StatelessWidget {
  final ProgressUnit unit;
  final int currentProgress;
  final int? totalProgress;
  final int? currentVolume;
  final int? totalVolumes;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onDirectProgressSet;
  final ValueChanged<int?>? onDirectVolumeSet;
  final ValueChanged<int?>? onDirectTotalSet;
  final ValueChanged<int?>? onDirectTotalVolumesSet;

  const ProgressStepperWidget({
    super.key,
    required this.unit,
    required this.currentProgress,
    this.totalProgress,
    this.currentVolume,
    this.totalVolumes,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDirectProgressSet,
    this.onDirectVolumeSet,
    this.onDirectTotalSet,
    this.onDirectTotalVolumesSet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Volume selector row if volumeChapter
          if (unit == ProgressUnit.volumeChapter) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Volume: ',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showNumberDialog(
                    context: context,
                    title: 'Set Volume',
                    initialValue: currentVolume ?? 1,
                    onSaved: (val) => onDirectVolumeSet?.call(val),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentVolume ?? 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (onDirectTotalVolumesSet != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      '/',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showNullableNumberDialog(
                      context: context,
                      title: 'Set Total Volumes',
                      initialValue: totalVolumes,
                      onSaved: (val) => onDirectTotalVolumesSet?.call(val),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        totalVolumes != null ? '$totalVolumes' : 'Total: --',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: totalVolumes != null
                              ? null
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ] else if (totalVolumes != null) ...[
                  Text(
                    ' / $totalVolumes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Stepper row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrement button
              IconButton.filledTonal(
                icon: const Icon(Icons.remove_rounded, size: 22),
                onPressed: currentProgress > 0
                    ? () {
                        HapticFeedback.lightImpact();
                        onDecrement();
                      }
                    : null,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Current value and total progress
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _showNumberDialog(
                        context: context,
                        title: 'Set ${unit.label}',
                        initialValue: currentProgress,
                        onSaved: onDirectProgressSet,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          currentProgress.toString(),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    if (onDirectTotalSet != null &&
                        unit != ProgressUnit.percent) ...[
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _showNullableNumberDialog(
                          context: context,
                          title: 'Set Total ${unit.label}s',
                          initialValue: totalProgress,
                          onSaved: (val) => onDirectTotalSet?.call(val),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatSubtext(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.2,
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.dotted,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.edit_outlined,
                                size: 12,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        child: Text(
                          _formatSubtext(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Increment button
              IconButton.filled(
                icon: const Icon(Icons.add_rounded, size: 22),
                onPressed: (totalProgress != null &&
                        currentProgress >= totalProgress!)
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        onIncrement();
                      },
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSubtext() {
    switch (unit) {
      case ProgressUnit.chapter:
        return totalProgress != null ? 'of $totalProgress Chapters' : 'Chapters';
      case ProgressUnit.page:
        return totalProgress != null ? 'of $totalProgress Pages' : 'Pages';
      case ProgressUnit.volume:
        return totalProgress != null ? 'of $totalProgress Volumes' : 'Volumes';
      case ProgressUnit.volumeChapter:
        return totalProgress != null ? 'of $totalProgress Chapters' : 'Chapters';
      case ProgressUnit.words:
        return totalProgress != null ? 'of $totalProgress Words' : 'Words';
      case ProgressUnit.percent:
        return '% Completed';
    }
  }

  void _showNumberDialog({
    required BuildContext context,
    required String title,
    required int initialValue,
    required ValueChanged<int> onSaved,
  }) {
    final controller = TextEditingController(text: initialValue.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Number'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final val = int.tryParse(controller.text.trim());
                if (val != null && val >= 0) {
                  onSaved(val);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _showNullableNumberDialog({
    required BuildContext context,
    required String title,
    required int? initialValue,
    required ValueChanged<int?> onSaved,
  }) {
    final controller = TextEditingController(
      text: initialValue != null ? initialValue.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Total Count',
              hintText: 'Leave empty if ongoing / unknown',
            ),
          ),
          actions: [
            if (initialValue != null)
              TextButton(
                onPressed: () {
                  onSaved(null);
                  Navigator.pop(ctx);
                },
                child: const Text('Clear'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  onSaved(null);
                } else {
                  final val = int.tryParse(text);
                  if (val != null && val >= 0) {
                    onSaved(val);
                  }
                }
                Navigator.pop(ctx);
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }
}
