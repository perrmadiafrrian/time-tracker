import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/data/repositories/settings_repository.dart';
import 'package:time_tracker/data/repositories/summary_repository.dart';
import 'package:time_tracker/data/repositories/task_repository.dart';
import 'package:time_tracker/data/repositories/time_entry_repository.dart';
import 'package:time_tracker/data/tasks_dao.dart';
import 'package:time_tracker/data/time_entries_dao.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() async {
    await db.close();
  });
  return db;
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TaskRepository(db);
}

@Riverpod(keepAlive: true)
TimeEntryRepository timeEntryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TimeEntryRepository(db);
}

@Riverpod(keepAlive: true)
SummaryRepository summaryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return SummaryRepository(db);
}

@Riverpod(keepAlive: true)
TasksDao tasksDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TasksDao(db);
}

@Riverpod(keepAlive: true)
TimeEntriesDao timeEntriesDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TimeEntriesDao(db);
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsProvider = FutureProvider<Settings>((ref) async {
  final SettingsRepository repo = ref.watch(settingsRepositoryProvider);
  return repo.load();
});
