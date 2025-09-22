import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:time_tracker/features/tracking/view_models.dart';

class EntriesList extends ConsumerStatefulWidget {
  const EntriesList({super.key});

  @override
  ConsumerState<EntriesList> createState() => _EntriesListState();
}

class _EntriesListState extends ConsumerState<EntriesList> {
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
    final entriesStream = ref.watch(todayEntriesProvider);
    return entriesStream.when(
      data: (list) => StreamBuilder(
        stream: ref
            .watch(app_providers.tasksDaoProvider)
            .watchAll(includeArchived: true),
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? const [];
          final Map<String, String> idToName = {
            for (final t in tasks) t.id: t.name,
          };
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = list[index];
              final isRunning = e.end == null;
              final icon = isRunning
                  ? Icons.play_arrow
                  : Icons.check_circle_outline;
              final duration = (e.end ?? DateTime.now().toUtc()).difference(
                e.start,
              );
              final taskName = idToName[e.taskId] ?? e.taskId;
              return ListTile(
                leading: Icon(icon),
                title: Text(taskName),
                subtitle: Text(_formatRange(e.start, e.end)),
                trailing: Text(_formatDuration(duration)),
              );
            },
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error: $err')),
    );
  }

  String _formatRange(DateTime start, DateTime? end) {
    final s = TimeOfDay.fromDateTime(start.toLocal());
    final e = end == null ? null : TimeOfDay.fromDateTime(end.toLocal());
    final sStr =
        '${s.hour.toString().padLeft(2, '0')}:${s.minute.toString().padLeft(2, '0')}';
    final eStr = e == null
        ? '…'
        : '${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}';
    return '$sStr - $eStr';
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return [h, m, s].map((v) => v.toString().padLeft(2, '0')).join(':');
  }
}
