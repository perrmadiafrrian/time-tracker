import 'package:time_tracker/core/result.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/data/tasks_dao.dart';

class TaskRepository {
  final AppDatabase db;
  final TasksDao dao;

  TaskRepository(this.db) : dao = TasksDao(db);

  Future<Result<Task>> create({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      await dao.createTask(
        id: id,
        name: name,
        description: description,
        createdAt: now,
      );
      final created = await dao.getById(id);
      if (created == null) {
        return const FailureResult(DatabaseFailure('Failed to fetch created task'));
      }
      return Success(created);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to create task', cause: e, stackTrace: st));
    }
  }

  Future<Result<List<Task>>> all({bool includeArchived = false}) async {
    try {
      final list = await dao.getAll(includeArchived: includeArchived);
      return Success(list);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to load tasks', cause: e, stackTrace: st));
    }
  }

  Future<Result<bool>> update({
    required String id,
    String? name,
    String? description,
    bool? isArchived,
  }) async {
    try {
      final ok = await dao.updateTask(
        id: id,
        name: name,
        description: description,
        isArchived: isArchived,
      );
      return Success(ok);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to update task', cause: e, stackTrace: st));
    }
  }

  Future<Result<int>> delete(String id) async {
    try {
      final n = await dao.deleteTask(id);
      return Success(n);
    } catch (e, st) {
      return FailureResult(DatabaseFailure('Failed to delete task', cause: e, stackTrace: st));
    }
  }
}


