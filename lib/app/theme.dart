import 'package:flutter/material.dart';

ThemeData buildLightTheme({Color seedColor = const Color(0xFF6750A4)}) {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: false),
    scaffoldBackgroundColor: scheme.surface,
  );
}

ThemeData buildDarkTheme({Color seedColor = const Color(0xFF6750A4)}) {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: false),
    scaffoldBackgroundColor: scheme.surface,
  );
}
