import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart';
import 'package:time_tracker/data/local_db.dart';
import 'package:time_tracker/features/tracking/view_models.dart';
import 'package:tray_manager/tray_manager.dart';

class TraySync extends ConsumerWidget {
  const TraySync({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<TimeEntry?>>(activeEntryProvider, (prev, next) async {
      final entry = ref.read(activeEntryProvider).value;
      final taskRepo = ref.read(taskRepositoryProvider);
      if (entry == null) {
        await trayManager.setTitle('Break');
        await trayManager.setToolTip('On Break');
      } else {
        final tasks = await taskRepo.all(includeArchived: true);
        String label = entry.taskId;
        tasks.when(
          success: (list) {
            for (final t in list) {
              if (t.id == entry.taskId) {
                label = t.name;
                break;
              }
            }
          },
          failure: (_) {},
        );
        await trayManager.setTitle(label);
        await trayManager.setToolTip('Working on $label');
      }
    });
    return const SizedBox.shrink();
  }
}
