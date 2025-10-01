import 'package:drift/drift.dart';
import 'package:time_tracker/data/local_db.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  Future<int> createTask({
    required String id,
    required String name,
    String? description,
    required DateTime createdAt,
  }) {
    return into(tasks).insert(
      TasksCompanion.insert(
        id: id,
        name: name,
        description: Value(description),
        isArchived: const Value(false),
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
  }

  Future<Task?> getById(String id) {
    return (select(tasks)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<Task?> getByName(String name) {
    return (select(tasks)..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  Future<List<Task>> getAll({bool includeArchived = false}) {
    final query = select(tasks)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.get();
  }

  Future<bool> updateTask({
    required String id,
    String? name,
    String? description,
    bool? isArchived,
  }) async {
    final companion = TasksCompanion(
      name: name == null ? const Value.absent() : Value(name),
      description: description == null
          ? const Value.absent()
          : Value(description),
      isArchived: isArchived == null ? const Value.absent() : Value(isArchived),
      updatedAt: Value(DateTime.now().toUtc()),
    );
    final rows = await (update(
      tasks,
    )..where((t) => t.id.equals(id))).write(companion);
    return rows > 0;
  }

  Future<int> deleteTask(String id) {
    return (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<Task>> watchAll({bool includeArchived = true}) {
    final query = select(tasks)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }
    return query.watch();
  }

  Future<bool> archiveTask(String id) async {
    return updateTask(id: id, isArchived: true);
  }

  Stream<List<Task>> watchToday({bool includeArchived = false}) {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final query = select(tasks)
      ..where(
        (t) =>
            t.createdAt.isBiggerOrEqualValue(todayStart) &
            t.createdAt.isSmallerThanValue(tomorrowStart),
      )
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (!includeArchived) {
      query.where((t) => t.isArchived.equals(false));
    }

    return query.watch();
  }

  Future<int> archiveTasksFromYesterday() async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);

    return (update(tasks)..where(
          (t) =>
              t.createdAt.isSmallerThanValue(todayStart) &
              t.isArchived.equals(false),
        ))
        .write(const TasksCompanion(isArchived: Value(true)));
  }

  Future<Task?> getTodayByName(String name) async {
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    return (select(tasks)..where(
          (t) =>
              t.name.equals(name) &
              t.createdAt.isBiggerOrEqualValue(todayStart) &
              t.createdAt.isSmallerThanValue(tomorrowStart) &
              t.isArchived.equals(false),
        ))
        .getSingleOrNull();
  }
}
