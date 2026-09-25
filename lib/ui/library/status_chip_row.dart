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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: items.map((item) {
          final isSelected = activeStatus == item.status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text('${item.label} (${item.count})'),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              onSelected: (_) {
                ref.read(libraryFilterProvider.notifier).setStatus(item.status);
              },
            ),
          );
        }).toList(),
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
