import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/features/tracking/view_models.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dailySummaryProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: summary.when(
          data: (d) {
            final entries = d.taskDurations.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.summarize),
                    const SizedBox(width: 8),
                    Text('Today Total: ${_formatDuration(d.totalDuration)}'),
                  ],
                ),
                const SizedBox(height: 8),
                ...entries.map((e) => Row(
                      children: [
                        const Icon(Icons.work_outline, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(e.key, overflow: TextOverflow.ellipsis)),
                        Text(_formatDuration(e.value)),
                      ],
                    )),
              ],
            );
          },
          loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
          error: (err, st) => Text('Error: $err'),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '${h}h ${m}m';
  }
}


