import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/features/tracking/view_models.dart';

void main() {
  test('Tracking flow: Start → Switch → Break → Resume Previous → Stop', () async {
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(AppDatabase.memory()),
    ]);
    addTearDown(container.dispose);

    final vm = container.read(trackingViewModelProvider.notifier);

    await vm.startTaskByName(name: 'Task A');
    final active1 = await container.read(timeEntryRepositoryProvider).active();
    expect(active1.isSuccess, true);
    active1.when(
      success: (v) => expect(v, isNotNull),
      failure: (e) => fail('expected success, got $e'),
    );
    final firstTaskId = container.read(trackingViewModelProvider).lastNonBreakTaskId;
    expect(firstTaskId, isNotNull);

    await vm.switchTaskByName(name: 'Task B');
    final activeAfterSwitch = await container.read(timeEntryRepositoryProvider).active();
    String? secondTaskId;
    activeAfterSwitch.when(
      success: (v) => secondTaskId = v?.taskId,
      failure: (e) => fail('expected success, got $e'),
    );
    expect(secondTaskId, isNotNull);
    expect(secondTaskId, isNot(equals(firstTaskId)));

    await vm.startBreak();
    final active2 = await container.read(timeEntryRepositoryProvider).active();
    active2.when(
      success: (v) => expect(v, isNull),
      failure: (e) => fail('expected success, got $e'),
    );

    await vm.resumePreviousTask();
    final active3 = await container.read(timeEntryRepositoryProvider).active();
    active3.when(
      success: (v) => expect(v?.taskId, equals(secondTaskId)),
      failure: (e) => fail('expected success, got $e'),
    );

    await vm.stopCurrent();
    final active4 = await container.read(timeEntryRepositoryProvider).active();
    active4.when(
      success: (v) => expect(v, isNull),
      failure: (e) => fail('expected success, got $e'),
    );
  });
}


