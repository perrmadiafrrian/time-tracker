import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:time_tracker/features/tracking/view_models.dart';

// Global navigator for surfacing dialogs from outside widget tree (e.g., tray)
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> promptStartOrSwitchTask(BuildContext context) async {
  final container = ProviderScope.containerOf(context);
  final vm = container.read(trackingViewModelProvider.notifier);
  final hasActive = container.read(activeEntryProvider).valueOrNull != null;
  final isPaused = container.read(isBreakPausedProvider);
  final bool shouldSwitch = hasActive || isPaused;
  final controller = TextEditingController();
  final String? name = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(shouldSwitch ? 'Switch Task' : 'Start Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Task name'),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(shouldSwitch ? 'Switch' : 'Start'),
          ),
        ],
      );
    },
  );
  final trimmed = name?.trim();
  if (trimmed == null || trimmed.isEmpty) return;
  if (shouldSwitch) {
    await vm.switchTaskByName(name: trimmed);
  } else {
    await vm.startTaskByName(name: trimmed);
  }
}

final isOnBreakProvider = FutureProvider<bool>((ref) async {
  final active = ref.watch(activeEntryProvider).valueOrNull;
  if (active == null) return false;
  final settings = await ref.watch(app_providers.settingsProvider.future);
  final dao = ref.watch(app_providers.tasksDaoProvider);
  final task = await dao.getById(active.taskId);
  if (task == null) return false;
  return task.name.trim() == settings.defaultBreakLabel.trim();
});

class AppMenuBar extends ConsumerWidget {
  const AppMenuBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!defaultTargetPlatform.toString().toLowerCase().contains('macos')) {
      return child;
    }
    final vm = ref.read(trackingViewModelProvider.notifier);
    final isOnBreak = ref.watch(isOnBreakProvider).valueOrNull ?? false;
    final isPaused = ref.watch(isBreakPausedProvider);
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'Time Tracker',
          menus: [
            PlatformMenuItem(
              label: 'Start/Switch',
              onSelected: () async {
                await promptStartOrSwitchTask(context);
              },
            ),
            PlatformMenuItem(
              label: isOnBreak || isPaused ? 'End Break' : 'Lunch Break',
              onSelected: () => (isOnBreak
                  ? vm.stopCurrent()
                  : (isPaused ? vm.resumePreviousTask() : vm.startBreak())),
            ),
            PlatformMenuItem(label: 'Stop', onSelected: () => vm.stopCurrent()),
          ],
        ),
      ],
      child: child,
    );
  }
}
