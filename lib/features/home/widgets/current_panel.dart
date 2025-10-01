import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:time_tracker/features/tracking/view_models.dart';

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
    final isPaused = ref.watch(isBreakPausedProvider);
    final vm = ref.read(trackingViewModelProvider.notifier);
    final now = DateTime.now().toUtc();
    final elapsed = entry == null
        ? Duration.zero
        : (entry.endAt ?? now).difference(entry.startAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Status',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: ref
                  .watch(app_providers.tasksDaoProvider)
                  .watchAll(includeArchived: true),
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? const [];
                final Map<String, String> idToName = {
                  for (final t in tasks) t.id: t.name,
                };

                String statusLabel;
                String statusDescription;
                Color statusColor;

                if (isPaused) {
                  statusLabel = 'On Break';
                  statusDescription = 'No active task';
                  statusColor = Theme.of(context).colorScheme.tertiary;
                } else if (entry == null) {
                  statusLabel = 'Not Working';
                  statusDescription = 'No active task';
                  statusColor = Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5);
                } else {
                  statusLabel = 'Working';
                  statusDescription = idToName[entry.taskId] ?? 'Loading…';
                  statusColor = Theme.of(context).colorScheme.primary;
                }

                return Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            statusLabel,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            statusDescription,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDuration(elapsed),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            // Control buttons
            Row(
              children: [
                if (entry != null || isPaused) ...[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        if (isPaused) {
                          await vm.resumePreviousTask();
                        } else {
                          await vm.startBreak();
                        }
                      },
                      icon: SvgPicture.asset(
                        isPaused
                            ? 'assets/icons/resume.svg'
                            : 'assets/icons/pause.svg',
                        width: 16,
                        height: 16,
                      ),
                      label: Text(isPaused ? 'End Break' : 'Break'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (entry != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await vm.stopCurrent();
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/stop.svg',
                        width: 16,
                        height: 16,
                      ),
                      label: const Text('Stop'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                if (entry == null && !isPaused)
                  Expanded(
                    child: Text(
                      'Start a task from the list below',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
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
