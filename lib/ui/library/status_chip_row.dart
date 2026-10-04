import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/reading_status.dart';
import 'library_providers.dart';

class StatusChipRow extends ConsumerWidget {
  const StatusChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStatus =
        ref.watch(libraryFilterProvider.select((s) => s.status));
    final countsAsync = ref.watch(statusCountsStreamProvider);
    final counts = countsAsync.value ?? {};
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = [
      _StatusItem(null, 'All', counts['all'] ?? 0),
      _StatusItem(ReadingStatus.reading, ReadingStatus.reading.label,
          counts[ReadingStatus.reading.value] ?? 0),
      _StatusItem(ReadingStatus.planToRead, ReadingStatus.planToRead.label,
          counts[ReadingStatus.planToRead.value] ?? 0),
      _StatusItem(ReadingStatus.onHold, ReadingStatus.onHold.label,
          counts[ReadingStatus.onHold.value] ?? 0),
      _StatusItem(ReadingStatus.completed, ReadingStatus.completed.label,
          counts[ReadingStatus.completed.value] ?? 0),
      _StatusItem(ReadingStatus.dropped, ReadingStatus.dropped.label,
          counts[ReadingStatus.dropped.value] ?? 0),
    ];

    return SizedBox(
      height: 46,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.02, 0.98, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = activeStatus == item.status;

            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  ref.read(libraryFilterProvider.notifier).setStatus(item.status);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.secondaryContainer
                        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.onSecondaryContainer.withValues(alpha: 0.12)
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${item.count}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11,
                            color: isSelected
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusItem {
  final ReadingStatus? status;
  final String label;
  final int count;

  _StatusItem(this.status, this.label, this.count);
}

