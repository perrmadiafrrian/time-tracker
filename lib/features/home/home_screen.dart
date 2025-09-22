import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/tray_sync.dart';
import 'package:time_tracker/features/home/widgets/current_panel.dart';
import 'package:time_tracker/features/home/widgets/entries_list.dart';
import 'package:time_tracker/features/home/widgets/quick_actions.dart';
import 'package:time_tracker/features/home/widgets/summary_card.dart';
import 'package:time_tracker/features/home/widgets/settings_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                TraySync(),
                CurrentPanel(),
                SizedBox(height: 16),
                QuickActions(),
                SizedBox(height: 16),
                SummaryCard(),
                SizedBox(height: 16),
                Expanded(child: EntriesList()),
              ],
            ),
          );
        },
      ),
    );
  }
}
