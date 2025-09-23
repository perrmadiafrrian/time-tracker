import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/core/result.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/data/repositories/summary_repository.dart';
import 'package:time_tracker/data/repositories/task_repository.dart';
import 'package:time_tracker/data/repositories/time_entry_repository.dart';

AppDatabase _makeMemoryDb() => AppDatabase.memory();

void main() {
  group('Repositories', () {
    late AppDatabase db;
    late TaskRepository tasks;
    late TimeEntryRepository entries;
    late SummaryRepository summary;

    setUp(() {
      db = _makeMemoryDb();
      tasks = TaskRepository(db);
      entries = TimeEntryRepository(db);
      summary = SummaryRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('Task CRUD', () async {
      final res = await tasks.create(id: 't1', name: 'Task 1');
      expect(res.isSuccess, true);
      final list = await tasks.all();
      expect(list.isSuccess, true);
      expect((list as Success<List<Task>>).value.length, 1);
      final updated = await tasks.update(id: 't1', name: 'Task 1b');
      expect(updated.isSuccess, true);
      final deleted = await tasks.delete('t1');
      expect(deleted.isSuccess, true);
    });

    test(
      'Start/Stop/Switch Time Entries and Summary excludes breaks',
      () async {
        await tasks.create(id: 'work', name: 'Work');
        await tasks.create(id: 'break', name: 'Lunch Break');
        final now = DateTime.now().toUtc();
        await entries.start(id: 'e1', taskId: 'work', startAt: now);
        await entries.stop(
          id: 'e1',
          endAt: now.add(const Duration(minutes: 30)),
        );
        await entries.start(
          id: 'e2',
          taskId: 'break',
          startAt: now.add(const Duration(minutes: 30)),
        );
        await entries.stop(
          id: 'e2',
          endAt: now.add(const Duration(minutes: 45)),
        );
        await entries.start(
          id: 'e3',
          taskId: 'work',
          startAt: now.add(const Duration(minutes: 45)),
        );
        await entries.stop(id: 'e3', endAt: now.add(const Duration(hours: 1)));

        final day = DateTime.utc(now.year, now.month, now.day);
        final total = await summary.totalForDay(day);
        expect(total.isSuccess, true);
        final duration = (total as Success<Duration>).value;
        expect(duration, const Duration(minutes: 45));
      },
    );
  });
}
