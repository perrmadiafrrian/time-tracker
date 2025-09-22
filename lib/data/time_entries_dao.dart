import 'package:drift/drift.dart';
import 'package:time_tracker/data/local_db.dart';

part 'time_entries_dao.g.dart';

@DriftAccessor(tables: [TimeEntries, Tasks])
class TimeEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$TimeEntriesDaoMixin {
  TimeEntriesDao(super.db);

  Future<int> startEntry({
    required String id,
    required String taskId,
    required DateTime startAt,
    String? note,
  }) {
    return into(timeEntries).insert(TimeEntriesCompanion.insert(
      id: id,
      taskId: taskId,
      startAt: startAt,
      endAt: const Value.absent(),
      note: Value(note),
    ));
  }

  Future<bool> stopEntry(String id, DateTime endAt) async {
    final rows = await (update(timeEntries)..where((t) => t.id.equals(id))).write(
      TimeEntriesCompanion(endAt: Value(endAt)),
    );
    return rows > 0;
  }

  Future<bool> switchTask({
    required String currentEntryId,
    required String newEntryId,
    required String newTaskId,
    required DateTime switchAt,
  }) async {
    return transaction(() async {
      final stopped = await stopEntry(currentEntryId, switchAt);
      if (!stopped) return false;
      await startEntry(id: newEntryId, taskId: newTaskId, startAt: switchAt);
      return true;
    });
  }

  Future<TimeEntry?> getActiveEntry() {
    return (select(timeEntries)..where((t) => t.endAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.startAt, mode: OrderingMode.desc)])
    ).getSingleOrNull();
  }

  Future<List<TimeEntry>> entriesForDay(DateTime dayUtc) {
    final DateTime start = DateTime.utc(dayUtc.year, dayUtc.month, dayUtc.day);
    final DateTime end = start.add(const Duration(days: 1));
    return (select(timeEntries)
          ..where((t) => t.startAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.startAt)])).
        get();
  }

  Stream<TimeEntry?> watchActiveEntry() {
    final query = (select(timeEntries)..where((t) => t.endAt.isNull())
      ..orderBy([(t) => OrderingTerm(expression: t.startAt, mode: OrderingMode.desc)]));
    return query.watchSingleOrNull();
  }

  Stream<List<TimeEntry>> watchEntriesForDay(DateTime dayUtc) {
    final DateTime start = DateTime.utc(dayUtc.year, dayUtc.month, dayUtc.day);
    final DateTime end = start.add(const Duration(days: 1));
    final query = (select(timeEntries)
      ..where((t) => t.startAt.isBetweenValues(start, end))
      ..orderBy([(t) => OrderingTerm(expression: t.startAt, mode: OrderingMode.desc)]));
    return query.watch();
  }
}


