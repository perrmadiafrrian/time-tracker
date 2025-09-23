import 'package:drift/drift.dart';
import 'package:time_tracker/core/result.dart';
import 'package:time_tracker/data/local_db.dart';

class SummaryRepository {
  final AppDatabase db;
  SummaryRepository(this.db);

  Future<Result<List<TimeEntry>>> entriesForDay(DateTime dayUtc) async {
    try {
      final DateTime start = DateTime.utc(dayUtc.year, dayUtc.month, dayUtc.day);
      final DateTime end = start.add(const Duration(days: 1));
      final query = db.select(db.timeEntries)
        ..where((t) => t.startAt.isBetweenValues(start, end))
        ..orderBy([(t) => OrderingTerm(expression: t.startAt)]);
      final list = await query.get();
      return Success(list);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to load entries for day', cause: e, stackTrace: st));
    }
  }

  Future<Result<Duration>> totalForDay(DateTime dayUtc) async {
    try {
      final DateTime start = DateTime.utc(dayUtc.year, dayUtc.month, dayUtc.day);
      final DateTime end = start.add(const Duration(days: 1));
      final join = (db.select(db.timeEntries).join([
        innerJoin(db.tasks, db.tasks.id.equalsExp(db.timeEntries.taskId)),
      ])
        ..where(db.timeEntries.startAt.isBetweenValues(start, end))
        ..where(db.tasks.name.collate(Collate.noCase).like('%break%').not()));

      final rows = await join.get();
      Duration total = Duration.zero;
      for (final row in rows) {
        final e = row.readTable(db.timeEntries);
        final DateTime effectiveEnd = e.endAt ?? DateTime.now().toUtc();
        if (!effectiveEnd.isAfter(e.startAt)) continue;
        total += effectiveEnd.difference(e.startAt);
      }
      return Success(total);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to compute total', cause: e, stackTrace: st));
    }
  }
}


