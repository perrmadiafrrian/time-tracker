import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/app/app.dart';
import 'package:time_tracker/app/theme.dart';
import 'package:time_tracker/core/window_utils.dart';
import 'package:time_tracker/features/home/home_screen.dart';
import 'package:tray_manager/tray_manager.dart';

class _TrayHandler with TrayListener {
  void init() {
    trayManager.addListener(this);
  }

  void dispose() {
    trayManager.removeListener(this);
  }

  @override
  void onTrayIconMouseDown() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show_hide':
        await WindowUtils.toggleMainWindow();
        break;
      case 'start_switch':
        // This requires UI input for task name; consider prompting later
        break;
      case 'lunch_break':
        // This will be handled via provider in UI
        break;
      case 'resume_prev':
        break;
      case 'stop':
        break;
      case 'quit':
        await trayManager.destroy();
        break;
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _setupTray();
  runApp(const ProviderScope(child: MyApp()));
  // Ensure the window is shown and focused after the first frame on desktop
  WidgetsBinding.instance.addPostFrameCallback((_) {
    WindowUtils.showMainWindow();
  });
}

final _TrayHandler _trayHandler = _TrayHandler();

Future<void> _setupTray() async {
  _trayHandler.init();
  // Use an existing bundled asset for the tray icon to avoid missing asset issues during setup
  const String iconPath = 'web/favicon.png';
  await trayManager.setIcon(iconPath);
  final Menu menu = Menu(
    items: [
      MenuItem(key: 'show_hide', label: 'Show/Hide Window'),
      MenuItem.separator(),
      MenuItem(key: 'start_switch', label: 'Start/Switch'),
      MenuItem(key: 'lunch_break', label: 'Lunch Break'),
      MenuItem(key: 'resume_prev', label: 'Resume Previous'),
      MenuItem(key: 'stop', label: 'Stop'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: 'Quit'),
    ],
  );
  await trayManager.setContextMenu(menu);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: const AppMenuBar(child: HomeScreen()),
    );
  }
}

// Removed old counter home page; using HomeScreen instead.
