import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/tray_sync.dart';
import 'package:time_tracker/features/home/widgets/current_panel.dart';
import 'package:time_tracker/features/home/widgets/entries_list.dart';
import 'package:time_tracker/features/home/widgets/quick_actions.dart';
import 'package:time_tracker/features/home/widgets/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const TraySync(),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Expanded(flex: 3, child: CurrentPanel()),
                      SizedBox(width: 8),
                      Expanded(flex: 1, child: QuickActions()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SummaryCard(),
                const SizedBox(height: 16),
                const Expanded(child: EntriesList()),
              ],
            ),
          );
        },
      ),
    );
  }
}
