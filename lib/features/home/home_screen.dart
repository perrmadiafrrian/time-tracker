import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/tray_sync.dart';
import 'package:time_tracker/features/home/widgets/current_panel.dart';
import 'package:time_tracker/features/home/widgets/entries_list.dart';
import 'package:time_tracker/features/home/widgets/summary_card.dart';
import 'package:time_tracker/features/home/widgets/tasks_list.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use different layouts for different screen sizes
          final isWideScreen = constraints.maxWidth > 1200;

          if (isWideScreen) {
            // Wide screen: two column layout
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: Tasks and Current Status
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: const [
                        TraySync(),
                        CurrentPanel(),
                        SizedBox(height: 16),
                        Expanded(child: TasksList()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right column: Summary and Entries
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: const [
                        SummaryCard(),
                        SizedBox(height: 16),
                        Expanded(child: EntriesList()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Narrow screen: single column layout
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const TraySync(),
                  const CurrentPanel(),
                  const SizedBox(height: 16),
                  const SummaryCard(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            tabs: const [
                              Tab(icon: Icon(Icons.task), text: 'Tasks'),
                              Tab(icon: Icon(Icons.history), text: 'Entries'),
                            ],
                            labelColor: Theme.of(context).colorScheme.primary,
                          ),
                          const Expanded(
                            child: TabBarView(
                              children: [TasksList(), EntriesList()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
