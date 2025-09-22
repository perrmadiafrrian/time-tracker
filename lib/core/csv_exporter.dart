import 'package:time_tracker/domain/entities/time_entry.dart' as domain;

String _escapeCsv(String input) {
  final needsQuoting = input.contains(',') || input.contains('\n') || input.contains('"');
  String value = input.replaceAll('"', '""');
  if (needsQuoting) {
    value = '"$value"';
  }
  return value;
}

String exportTimeEntriesToCsv(List<domain.TimeEntry> entries) {
  final buffer = StringBuffer();
  // Header
  buffer.writeln('id,taskId,start,end,note,durationSeconds');
  for (final e in entries) {
    final id = _escapeCsv(e.id);
    final taskId = _escapeCsv(e.taskId);
    final start = e.start.toUtc().toIso8601String();
    final end = e.end?.toUtc().toIso8601String() ?? '';
    final note = _escapeCsv(e.note ?? '');
    final duration = (e.end ?? e.start).difference(e.start).inSeconds;
    buffer.writeln('$id,$taskId,$start,$end,$note,$duration');
  }
  return buffer.toString();
}


