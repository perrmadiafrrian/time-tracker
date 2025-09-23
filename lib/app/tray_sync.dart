import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/providers.dart' as app_providers;
import 'package:time_tracker/features/tracking/view_models.dart';
import 'package:tray_manager/tray_manager.dart';

class TraySync extends ConsumerStatefulWidget {
  const TraySync({super.key});

  @override
  ConsumerState<TraySync> createState() => _TraySyncState();
}

class _TraySyncState extends ConsumerState<TraySync> {
  Timer? _timer;
  String? _lastTaskId;
  String? _lastTaskName;
  String? _lastTooltip;

  // Map ASCII digits to Mathematical Monospace Digits to reduce width jitter
  static const List<String> _monoDigits = [
    '\u{1D7F6}', // 0
    '\u{1D7F7}', // 1
    '\u{1D7F8}', // 2
    '\u{1D7F9}', // 3
    '\u{1D7FA}', // 4
    '\u{1D7FB}', // 5
    '\u{1D7FC}', // 6
    '\u{1D7FD}', // 7
    '\u{1D7FE}', // 8
    '\u{1D7FF}', // 9
  ];

  String _toMonospaceDigits(String input) {
    final StringBuffer buf = StringBuffer();
    for (final int code in input.codeUnits) {
      if (code >= 48 && code <= 57) {
        // '0'..'9'
        buf.write(_monoDigits[code - 48]);
      } else {
        buf.writeCharCode(code);
      }
    }
    return buf.toString();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _tick() async {
    final active = ref.read(activeEntryProvider).value;
    if (active == null) {
      await trayManager.setTitle(
        _toMonospaceDigits(_formatDuration(Duration.zero)),
      );
      final desiredTooltip = 'On Break';
      if (_lastTooltip != desiredTooltip) {
        await trayManager.setToolTip(desiredTooltip);
        _lastTooltip = desiredTooltip;
      }
      _lastTaskId = null;
      _lastTaskName = null;
      return;
    }
    // Update title with elapsed time
    final DateTime now = DateTime.now().toUtc();
    final Duration elapsed = (active.endAt ?? now).difference(active.startAt);
    await trayManager.setTitle(_toMonospaceDigits(_formatDuration(elapsed)));

    // Update tooltip with task name if needed
    if (_lastTaskId != active.taskId || (_lastTaskName ?? '').isEmpty) {
      final dao = ref.read(app_providers.tasksDaoProvider);
      final task = await dao.getById(active.taskId);
      _lastTaskId = active.taskId;
      _lastTaskName = task?.name ?? 'Task';
    }
    final desiredTooltip = 'Working on ${_lastTaskName ?? 'Task'}';
    if (_lastTooltip != desiredTooltip) {
      await trayManager.setToolTip(desiredTooltip);
      _lastTooltip = desiredTooltip;
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return [h, m, s].map((v) => v.toString().padLeft(2, '0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
