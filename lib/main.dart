import 'dart:async';
import 'dart:io';

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
    // Left click: directly open the app window
    await WindowUtils.showMainWindow();
  }

  @override
  void onTrayIconRightMouseDown() async {
    // Right click: show context menu
    await trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show_hide':
        // Bring Up Window: always show and focus
        await WindowUtils.showMainWindow();
        break;
      case 'quit':
        await trayManager.destroy();
        exit(0);
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
  Future<void> applyTrayIcon() async {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final String iconPath = brightness == Brightness.dark
        ? 'assets/icons/tray_clock_dark.svg'
        : 'assets/icons/tray_clock_light.svg';
    await trayManager.setIcon(iconPath);
  }

  await applyTrayIcon();

  WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
    unawaited(applyTrayIcon());
  };
  // Simplified context menu for right-click only
  final Menu menu = Menu(
    items: [
      MenuItem(key: 'show_hide', label: 'Show Window'),
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
      navigatorKey: appNavigatorKey,
      home: const AppMenuBar(child: HomeScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Removed old counter home page; using HomeScreen instead.
