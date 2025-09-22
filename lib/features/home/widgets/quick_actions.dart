import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart';
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Task name',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onSubmitted: (_) => _startOrSwitch(vm, active != null),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => _startOrSwitch(vm, active != null),
          child: Text(active != null ? 'Switch' : 'Start'),
        ),
        const SizedBox(width: 8),
        Consumer(
          builder: (context, ref, _) {
            final settingsAsync = ref.watch(settingsProvider);
            final label =
                settingsAsync.valueOrNull?.defaultBreakLabel ?? 'Break';
            return FilledButton.icon(
              onPressed: () => vm.startBreak(),
              icon: const Icon(Icons.lunch_dining),
              label: Text(label),
            );
          },
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => vm.resumePreviousTask(),
          icon: const Icon(Icons.restore),
          label: const Text('Resume Previous'),
        ),
      ],
    );
  }

  void _startOrSwitch(TrackingViewModel vm, bool hasActive) {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    if (hasActive) {
      vm.switchTaskByName(name: name);
    } else {
      vm.startTaskByName(name: name);
    }
    _controller.clear();
  }
}
