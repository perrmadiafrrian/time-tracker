import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/data/tasks_dao.dart';
import 'package:time_tracker/domain/entities/daily_summary.dart' as domain;
import 'package:time_tracker/domain/entities/time_entry.dart' as domain;
import 'package:uuid/uuid.dart';

part 'view_models.g.dart';

final Uuid _uuid = const Uuid();

class TrackingState {
  final TimeEntry? currentEntry;
  final String? lastNonBreakTaskId;
  const TrackingState({this.currentEntry, this.lastNonBreakTaskId});

  TrackingState copyWith({
    TimeEntry? currentEntry,
    String? lastNonBreakTaskId,
  }) => TrackingState(
    currentEntry: currentEntry ?? this.currentEntry,
    lastNonBreakTaskId: lastNonBreakTaskId ?? this.lastNonBreakTaskId,
  );
}

@Riverpod(keepAlive: false)
class TrackingViewModel extends _$TrackingViewModel {
  @override
  TrackingState build() {
    ref.listen<AsyncValue<TimeEntry?>>(activeEntryProvider, (prev, next) {
      final current = next.value;
      if (current != null) {
        state = state.copyWith(
          currentEntry: current,
          lastNonBreakTaskId: current.taskId,
        );
      } else {
        state = state.copyWith(currentEntry: null);
      }
    });
    return const TrackingState();
  }

  Future<void> startTask({required String taskId, String? note}) async {
    final repo = ref.read(timeEntryRepositoryProvider);
    final id = _uuid.v4();
    await repo.start(
      id: id,
      taskId: taskId,
      startAt: DateTime.now().toUtc(),
      note: note,
    );
  }

  Future<void> startTaskByName({required String name, String? note}) async {
    final String taskId = await _resolveTaskIdByName(name);
    await startTask(taskId: taskId, note: note);
  }

  Future<void> switchTask({required String newTaskId}) async {
    final repo = ref.read(timeEntryRepositoryProvider);
    final currentRes = await repo.active();
    final current = currentRes.when(success: (v) => v, failure: (_) => null);
    if (current == null) {
      await startTask(taskId: newTaskId);
      return;
    }
    final newId = _uuid.v4();
    await repo.switchTask(
      currentEntryId: current.id,
      newEntryId: newId,
      newTaskId: newTaskId,
      switchAt: DateTime.now().toUtc(),
    );
  }

  Future<void> switchTaskByName({required String name}) async {
    final String taskId = await _resolveTaskIdByName(name);
    await switchTask(newTaskId: taskId);
  }

  Future<void> startBreak() async {
    // Pause current task: stop the active entry without creating a break task
    final repo = ref.read(timeEntryRepositoryProvider);
    final currentRes = await repo.active();
    final current = currentRes.when(success: (v) => v, failure: (_) => null);
    if (current != null) {
      // Ensure we remember the last non-break task id for resuming
      state = state.copyWith(lastNonBreakTaskId: current.taskId);
      await repo.stop(id: current.id, endAt: DateTime.now().toUtc());
    }
  }

  Future<String> _resolveTaskIdByName(String name) async {
    final TasksDao dao = ref.read(app_providers.tasksDaoProvider);
    // Check if task with this name exists today
    final existing = await dao.getTodayByName(name);
    if (existing != null) {
      state = state.copyWith(lastNonBreakTaskId: existing.id);
      return existing.id;
    }
    // Create new task for today
    final String id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await dao.createTask(id: id, name: name, description: null, createdAt: now);
    state = state.copyWith(lastNonBreakTaskId: id);
    return id;
  }

  Future<void> resumePreviousTask() async {
    final lastTaskId = state.lastNonBreakTaskId;
    if (lastTaskId != null) {
      await startTask(taskId: lastTaskId);
    }
  }

  Future<void> stopCurrent() async {
    final repo = ref.read(timeEntryRepositoryProvider);
    final currentRes = await repo.active();
    final current = currentRes.when(success: (v) => v, failure: (_) => null);
    if (current != null) {
      await repo.stop(id: current.id, endAt: DateTime.now().toUtc());
    }
  }

  Future<void> createTask({required String name, String? description}) async {
    final TasksDao dao = ref.read(app_providers.tasksDaoProvider);
    final String id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await dao.createTask(
      id: id,
      name: name,
      description: description,
      createdAt: now,
    );
  }
}

/// True when there is no active entry but we have a last non-break task id
final isBreakPausedProvider = Provider<bool>((ref) {
  final active = ref.watch(activeEntryProvider).valueOrNull;
  final state = ref.watch(trackingViewModelProvider);
  return active == null && state.lastNonBreakTaskId != null;
});

@riverpod
Stream<TimeEntry?> activeEntry(Ref ref) {
  final dao = ref.watch(app_providers.timeEntriesDaoProvider);
  return dao.watchActiveEntry();
}

domain.TimeEntry _mapToDomain(TimeEntry e) => domain.TimeEntry(
  id: e.id,
  taskId: e.taskId,
  start: e.startAt,
  end: e.endAt,
  note: e.note,
);

@riverpod
Stream<List<domain.TimeEntry>> todayEntries(Ref ref) {
  final dao = ref.watch(app_providers.timeEntriesDaoProvider);
  final now = DateTime.now().toUtc();
  return dao
      .watchEntriesForDay(DateTime.utc(now.year, now.month, now.day))
      .map((list) => list.map(_mapToDomain).toList());
}

@riverpod
Stream<domain.DailySummary> dailySummary(Ref ref) {
  final dao = ref.watch(app_providers.timeEntriesDaoProvider);
  final DateTime now = DateTime.now().toUtc();
  final DateTime day = DateTime.utc(now.year, now.month, now.day);

  final StreamController<domain.DailySummary> controller =
      StreamController<domain.DailySummary>();

  List<TimeEntry> latestEntries = <TimeEntry>[];

  void emitSummary() {
    Duration total = Duration.zero;
    final Map<String, Duration> byTask = <String, Duration>{};
    // Only count completed entries (endAt is not null)
    // Active entries will be handled by _LiveTaskDuration
    for (final e in latestEntries) {
      if (e.endAt == null) continue; // Skip active entries
      final DateTime endAt = e.endAt!;
      if (!endAt.isAfter(e.startAt)) continue;
      final Duration d = endAt.difference(e.startAt);
      total += d;
      byTask.update(e.taskId, (v) => v + d, ifAbsent: () => d);
    }
    if (!controller.isClosed) {
      controller.add(
        domain.DailySummary(
          date: day,
          totalDuration: total,
          taskDurations: byTask,
        ),
      );
    }
  }

  final StreamSubscription<List<TimeEntry>> entriesSub = dao
      .watchEntriesForDay(day)
      .listen((List<TimeEntry> entries) {
        latestEntries = entries;
        emitSummary();
      });

  // No need for ticker since we only count completed entries
  ref.onDispose(() async {
    await entriesSub.cancel();
    await controller.close();
  });

  return controller.stream;
}
