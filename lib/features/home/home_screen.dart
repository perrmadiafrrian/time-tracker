import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/tray_sync.dart';
import 'package:time_tracker/features/home/widgets/current_panel.dart';
import 'package:time_tracker/features/home/widgets/tasks_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            TraySync(),
            CurrentPanel(),
            SizedBox(height: 16),
            Expanded(child: TasksList()),
          ],
        ),
      ),
    );
  }
}
