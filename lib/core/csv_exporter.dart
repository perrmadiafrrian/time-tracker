import 'package:time_tracker/domain/entities/time_entry.dart' as domain;
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _escapeCsv(String input) {
  final needsQuoting =
      input.contains(',') || input.contains('\n') || input.contains('"');
  String value = input.replaceAll('"', '""');
  if (needsQuoting) {
    value = '"$value"';
  }
  return value;
}

/// Export only Task Name and Time Spent (hh:mm:ss) aggregated for the day.
Future<String> exportTaskDurationsCsv(
  WidgetRef ref,
  List<domain.TimeEntry> entries,
) async {
  final tasksDao = ref.read(app_providers.tasksDaoProvider);
  // Aggregate durations by taskId
  final Map<String, Duration> byTask = <String, Duration>{};
  for (final e in entries) {
    final endAt = e.end ?? DateTime.now().toUtc();
    if (!endAt.isAfter(e.start)) continue;
    final d = endAt.difference(e.start);
    byTask.update(e.taskId, (v) => v + d, ifAbsent: () => d);
  }

  // Resolve task names
  final Map<String, String> taskIdToName = <String, String>{};
  for (final taskId in byTask.keys) {
    final t = await tasksDao.getById(taskId);
    taskIdToName[taskId] = t?.name ?? taskId;
  }

  String _fmt(Duration d) {
    final two = (int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${two(hours)}:${two(minutes)}:${two(seconds)}';
  }

  final buffer = StringBuffer();
  buffer.writeln('Task Name,Time Spent');
  for (final entry in byTask.entries) {
    final name = _escapeCsv(taskIdToName[entry.key] ?? entry.key);
    final dur = _fmt(entry.value);
    buffer.writeln('$name,$dur');
  }
  return buffer.toString();
}
