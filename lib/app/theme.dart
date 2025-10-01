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

// VSCode Dark Theme inspired colors
ThemeData buildDarkTheme() {
  const vscodeBackground = Color(0xFF1e1e1e); // Main background
  const vscodeSurface = Color(0xFF252526); // Sidebar/surface
  const vscodePanel = Color(0xFF2d2d30); // Panel background
  const vscodeBorder = Color(0xFF3e3e42); // Border color
  const vscodeBlue = Color(0xFF007acc); // Accent blue
  const vscodeText = Color(0xFFcccccc); // Main text
  const vscodeTextDim = Color(0xFF858585); // Secondary text
  const vscodeRed = Color(0xFFf48771); // Error/stop

  final ColorScheme scheme = ColorScheme.dark(
    // Background colors
    surface: vscodeSurface,
    surfaceContainerHighest: vscodePanel,
    surfaceContainerHigh: vscodePanel,
    surfaceContainer: vscodeSurface,

    // Primary colors (VSCode blue accent)
    primary: vscodeBlue,
    primaryContainer: const Color(0xFF1a5490),
    onPrimary: Colors.white,
    onPrimaryContainer: const Color(0xFFd4e9ff),

    // Secondary colors
    secondary: const Color(0xFF569cd6), // Lighter blue
    secondaryContainer: const Color(0xFF3e5a7d),
    onSecondary: Colors.white,
    onSecondaryContainer: const Color(0xFFd4e9ff),

    // Tertiary (for breaks/pauses) - using a warmer, more pleasant orange/amber
    tertiary: const Color(0xFFdba56c), // Warmer, less harsh orange
    tertiaryContainer: const Color(0xFF8a5a44),
    onTertiary: const Color(0xFF1e1e1e), // Dark text for better contrast
    onTertiaryContainer: const Color(0xFFffdcc8),

    // Error colors
    error: vscodeRed,
    errorContainer: const Color(0xFF93000a),
    onError: Colors.white,
    onErrorContainer: const Color(0xFFffdad6),

    // Text colors
    onSurface: vscodeText,
    onSurfaceVariant: vscodeTextDim,

    // Outline/border
    outline: vscodeBorder,
    outlineVariant: const Color(0xFF2d2d30),
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: vscodeBackground,

    // AppBar theme
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: vscodeSurface,
      foregroundColor: vscodeText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // Card theme
    cardTheme: CardThemeData(
      color: vscodeSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: vscodeBorder.withValues(alpha: 0.3), width: 1),
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(color: vscodeBorder, thickness: 1),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: vscodePanel,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: vscodeBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: vscodeBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: vscodeBlue, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),

    // Button themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: vscodeBlue,
        foregroundColor: Colors.white,
        disabledBackgroundColor: vscodePanel,
        disabledForegroundColor: vscodeTextDim,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: vscodeText,
        side: BorderSide(color: vscodeBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: vscodeBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: vscodeSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: vscodeBorder),
      ),
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: vscodePanel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: vscodeText,
      unselectedLabelColor: vscodeTextDim,
      indicatorColor: vscodeBlue,
      dividerColor: vscodeBorder,
    ),
  );
}
