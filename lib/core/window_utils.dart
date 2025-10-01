import 'dart:ui';

import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

class WindowUtils {
  static Future<void> ensureInitialized() async {
    await windowManager.ensureInitialized();
  }

  static Future<void> showMainWindow() async {
    await ensureInitialized();

    // Position window on the screen where the cursor is
    await _positionWindowOnCursorScreen();

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

  static Future<void> _positionWindowOnCursorScreen() async {
    try {
      // Get cursor position
      final cursorScreenPoint = await screenRetriever.getCursorScreenPoint();

      // Get all displays
      final displays = await screenRetriever.getAllDisplays();

      // Find which display contains the cursor
      Display? targetDisplay;
      for (final display in displays) {
        final visiblePosition = display.visiblePosition!;
        final visibleSize = display.visibleSize!;

        if (cursorScreenPoint.dx >= visiblePosition.dx &&
            cursorScreenPoint.dx < visiblePosition.dx + visibleSize.width &&
            cursorScreenPoint.dy >= visiblePosition.dy &&
            cursorScreenPoint.dy < visiblePosition.dy + visibleSize.height) {
          targetDisplay = display;
          break;
        }
      }

      // If we found the display, center the window on it
      if (targetDisplay != null) {
        final visiblePosition = targetDisplay.visiblePosition!;
        final visibleSize = targetDisplay.visibleSize!;
        final windowSize = await windowManager.getSize();

        // Calculate center position on the target display
        final centerX =
            visiblePosition.dx + (visibleSize.width - windowSize.width) / 2;
        final centerY =
            visiblePosition.dy + (visibleSize.height - windowSize.height) / 2;

        await windowManager.setPosition(Offset(centerX, centerY));
      }
    } catch (e) {
      // If positioning fails, continue without positioning
      // The window will appear in its last position or default position
    }
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
