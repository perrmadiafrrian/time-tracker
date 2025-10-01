import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_tracker/app/app.dart' show promptStartOrSwitchTask;
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/core/csv_exporter.dart';
import 'package:time_tracker/features/tracking/view_models.dart';

class QuickActions extends ConsumerStatefulWidget {
  const QuickActions({super.key});

  @override
  ConsumerState<QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends ConsumerState<QuickActions> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(trackingViewModelProvider.notifier);
    final active = ref.watch(activeEntryProvider).valueOrNull;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FilledButton.icon(
            onPressed: () => promptStartOrSwitchTask(context),
            icon: SvgPicture.asset(
              'assets/icons/start.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              (active != null || ref.read(isBreakPausedProvider))
                  ? 'Switch Task'
                  : 'Start Task',
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, _) {
              final settingsAsync = ref.watch(settingsProvider);
              final isPaused = ref.watch(isBreakPausedProvider);
              final label = isPaused
                  ? 'End Break'
                  : (settingsAsync.valueOrNull?.defaultBreakLabel ?? 'Break');
              return FilledButton.icon(
                onPressed: () =>
                    isPaused ? vm.resumePreviousTask() : vm.startBreak(),
                icon: SvgPicture.asset(
                  'assets/icons/play_pause.svg',
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(label),
              );
            },
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              // Ensure any running timer is stopped before exporting
              await vm.stopCurrent();
              final entries = await ref.read(todayEntriesProvider.future);
              final csv = await exportTaskDurationsCsv(ref, entries);
              if (!context.mounted) return;
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Today\'s CSV'),
                    content: SizedBox(
                      width: 500,
                      height: 300,
                      child: SingleChildScrollView(child: SelectableText(csv)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: csv));
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Copy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/clock.svg',
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: const Text('End Day'),
          ),
        ],
      ),
    );
  }

  // Deprecated: handled by promptStartOrSwitchTask dialog
}
