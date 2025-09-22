import 'package:time_tracker/core/result.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/data/time_entries_dao.dart';

class TimeEntryRepository {
  final AppDatabase db;
  final TimeEntriesDao dao;

  TimeEntryRepository(this.db) : dao = TimeEntriesDao(db);

  Future<Result<TimeEntry>> start({
    required String id,
    required String taskId,
    required DateTime startAt,
    String? note,
  }) async {
    try {
      await dao.startEntry(id: id, taskId: taskId, startAt: startAt, note: note);
      final entry = await (db.select(db.timeEntries)..where((t) => t.id.equals(id))).getSingle();
      return Success(entry);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to start entry', cause: e, stackTrace: st));
    }
  }

  Future<Result<bool>> stop({required String id, required DateTime endAt}) async {
    try {
      final ok = await dao.stopEntry(id, endAt);
      return Success(ok);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to stop entry', cause: e, stackTrace: st));
    }
  }

  Future<Result<bool>> switchTask({
    required String currentEntryId,
    required String newEntryId,
    required String newTaskId,
    required DateTime switchAt,
  }) async {
    try {
      final ok = await dao.switchTask(
        currentEntryId: currentEntryId,
        newEntryId: newEntryId,
        newTaskId: newTaskId,
        switchAt: switchAt,
      );
      return Success(ok);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to switch task', cause: e, stackTrace: st));
    }
  }

  Future<Result<TimeEntry?>> active() async {
    try {
      final current = await dao.getActiveEntry();
      return Success(current);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to get active entry', cause: e, stackTrace: st));
    }
  }

  Future<Result<List<TimeEntry>>> forDay(DateTime dayUtc) async {
    try {
      final list = await dao.entriesForDay(dayUtc);
      return Success(list);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to fetch day entries', cause: e, stackTrace: st));
    }
  }
}


