import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/features/tracking/view_models.dart';

class TasksList extends ConsumerStatefulWidget {
  const TasksList({super.key});

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  @override
  void initState() {
    super.initState();
    // Auto-archive tasks from yesterday when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoArchiveYesterdaysTasks();
    });
  }

  Future<void> _autoArchiveYesterdaysTasks() async {
    final tasksDao = ref.read(tasksDaoProvider);
    await tasksDao.archiveTasksFromYesterday();
  }

  @override
  Widget build(BuildContext context) {
    final tasksDao = ref.watch(tasksDaoProvider);
    final vm = ref.read(trackingViewModelProvider.notifier);
    final activeEntry = ref.watch(activeEntryProvider).valueOrNull;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tasks', style: Theme.of(context).textTheme.titleLarge),
                FilledButton.icon(
                  onPressed: () => _showAddTaskDialog(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Task'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: tasksDao.watchToday(includeArchived: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks today',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a task to start tracking time today',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final isActive = activeEntry?.taskId == task.id;

                    return ListTile(
                      leading: Icon(
                        isActive ? Icons.play_circle : Icons.circle_outlined,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      title: Text(
                        task.name,
                        style: TextStyle(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: task.description?.isNotEmpty == true
                          ? Text(task.description!)
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isActive)
                            Chip(
                              label: const Text('Active'),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontSize: 12,
                              ),
                              padding: EdgeInsets.zero,
                            )
                          else
                            FilledButton.icon(
                              onPressed: () async {
                                if (activeEntry != null) {
                                  await vm.switchTask(newTaskId: task.id);
                                } else {
                                  await vm.startTask(taskId: task.id);
                                }
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/start.svg',
                                width: 16,
                                height: 16,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              label: const Text('Start'),
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'edit') {
                                _showEditTaskDialog(context, ref, task);
                              } else if (value == 'archive') {
                                unawaited(tasksDao.archiveTask(task.id));
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'archive',
                                child: Row(
                                  children: [
                                    Icon(Icons.archive, size: 18),
                                    SizedBox(width: 8),
                                    Text('Archive'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddTaskDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                hintText: 'Enter task name',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter description',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      final name = nameController.text.trim();
      if (name.isNotEmpty) {
        final tasksDao = ref.read(tasksDaoProvider);
        final vm = ref.read(trackingViewModelProvider.notifier);

        // Check if task with same name already exists today
        final existing = await tasksDao.getTodayByName(name);
        if (existing != null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task with this name already exists today'),
              ),
            );
          }
          return;
        }

        // Create the task using the view model's method
        await vm.createTask(
          name: name,
          description: descriptionController.text.trim().isNotEmpty
              ? descriptionController.text.trim()
              : null,
        );
      }
    }

    nameController.dispose();
    descriptionController.dispose();
  }

  Future<void> _showEditTaskDialog(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final nameController = TextEditingController(text: task.name);
    final descriptionController = TextEditingController(
      text: task.description ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task Name',
                hintText: 'Enter task name',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter description',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      final name = nameController.text.trim();
      if (name.isNotEmpty) {
        final tasksDao = ref.read(tasksDaoProvider);
        await tasksDao.updateTask(
          id: task.id,
          name: name,
          description: descriptionController.text.trim().isNotEmpty
              ? descriptionController.text.trim()
              : null,
        );
      }
    }

    nameController.dispose();
    descriptionController.dispose();
  }
}
