import 'package:window_manager/window_manager.dart';

class WindowUtils {
  static Future<void> ensureInitialized() async {
    await windowManager.ensureInitialized();
  }

  static Future<void> showMainWindow() async {
    await ensureInitialized();
    final isVisible = await windowManager.isVisible();
    if (!isVisible) {
      await windowManager.show();
    }
    final isMinimized = await windowManager.isMinimized();
    if (isMinimized) {
      await windowManager.restore();
    }
    await windowManager.focus();
    await windowManager.setSkipTaskbar(false);
  }

  static Future<void> hideMainWindow() async {
    await ensureInitialized();
    await windowManager.hide();
  }

  static Future<void> toggleMainWindow() async {
    await ensureInitialized();
    final isVisible = await windowManager.isVisible();
    if (isVisible) {
      await hideMainWindow();
    } else {
      await showMainWindow();
    }
  }
}


