import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
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
                  style: theme.textTheme.labelLarge?.copyWith(
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
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentVolume ?? 1}${totalVolumes != null ? ' / $totalVolumes' : ''}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
                icon: const Icon(Icons.remove_rounded, size: 24),
                onPressed: currentProgress > 0 ? onDecrement : null,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
              ),
              const SizedBox(width: 20),

              // Current value clickable
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showNumberDialog(
                  context: context,
                  title: 'Set ${unit.label}',
                  initialValue: currentProgress,
                  onSaved: onDirectProgressSet,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Text(
                        currentProgress.toString(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        _formatSubtext(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Increment button
              IconButton.filled(
                icon: const Icon(Icons.add_rounded, size: 24),
                onPressed: onIncrement,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
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
}
