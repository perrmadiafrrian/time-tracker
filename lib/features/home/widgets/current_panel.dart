import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/features/tracking/view_models.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;

class CurrentPanel extends ConsumerStatefulWidget {
  const CurrentPanel({super.key});

  @override
  ConsumerState<CurrentPanel> createState() => _CurrentPanelState();
}

class _CurrentPanelState extends ConsumerState<CurrentPanel> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeEntryProvider);
    final entry = active.valueOrNull;
    final now = DateTime.now().toUtc();
    final elapsed = entry == null
        ? Duration.zero
        : (entry.endAt ?? now).difference(entry.startAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ref
                    .watch(app_providers.tasksDaoProvider)
                    .watchAll(includeArchived: true),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? const [];
                  final Map<String, String> idToName = {
                    for (final t in tasks) t.id: t.name,
                  };
                  final String label = entry == null
                      ? 'No active entry'
                      : 'Task: ${idToName[entry.taskId] ?? entry.taskId}';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(elapsed),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  );
                },
              ),
            ),
            if (entry != null)
              FilledButton.icon(
                onPressed: () =>
                    ref.read(trackingViewModelProvider.notifier).stopCurrent(),
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return [h, m, s].map((v) => v.toString().padLeft(2, '0')).join(':');
  }
}
