import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/features/tracking/view_models.dart';

class AppMenuBar extends ConsumerWidget {
  const AppMenuBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!defaultTargetPlatform.toString().toLowerCase().contains('macos')) {
      return child;
    }
    final vm = ref.read(trackingViewModelProvider.notifier);
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'Time Tracker',
          menus: [
            PlatformMenuItem(
              label: 'Start/Switch',
              onSelected: () {
                // This should open UI to enter task name; left as a no-op hook
              },
            ),
            PlatformMenuItem(
              label: 'Lunch Break',
              onSelected: () => vm.startBreak(),
            ),
            PlatformMenuItem(
              label: 'Resume Previous',
              onSelected: () => vm.resumePreviousTask(),
            ),
            PlatformMenuItem(
              label: 'Stop',
              onSelected: () => vm.stopCurrent(),
            ),
          ],
        ),
      ],
      child: child,
    );
  }
}


