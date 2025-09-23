# Time Tracker

Lightweight, cross‑platform time tracking app built with Flutter. Focused on desktop productivity with a system tray clock, quick task switching, and a simple daily CSV export.

## Features

- Start/Switch/Stop tracking tasks
- One‑click Lunch Break that pauses tracking and lets you resume the previous task
- System tray integration (desktop):
  - Tray icon adapts to light/dark mode
  - Tray title shows elapsed time in monospaced digits (reduced width jitter)
  - Tray tooltip shows current task or "On Break"
  - Context menu: Bring Up Window, Start/Switch, Lunch Break, Stop, Quit
- macOS menu bar items mirror quick actions
- Local persistence using SQLite (Drift)
- Daily CSV export: Task Name, Time Spent (hh:mm:ss)

## Getting started

Prerequisites:

- Flutter SDK installed and configured
- Desktop platforms enabled as needed (e.g., `flutter config --enable-macos-desktop`)

Install dependencies:

```bash
flutter pub get
```

Generate code (Riverpod and Drift):

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run (examples):

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# Mobile (limited features, no system tray)
flutter run -d ios
flutter run -d android
```

## Usage

- Start/Switch: Use the Start/Switch button, macOS menu, or tray menu to begin a task or switch to a new one.
- Lunch Break: Toggles a paused state with a configurable label (defaults to "Break"). Use it again to resume the previous task.
- Stop: Ends the current entry.
- End Day: Stops the current entry and shows today’s aggregated CSV (copyable).

## CSV export

The daily CSV export includes two columns:

- Task Name
- Time Spent (hh:mm:ss)

The data aggregates all entries for the current day by task.

## Data storage

- Database: SQLite via Drift at the platform‑specific Application Support directory, file `time_tracker.db`.
- Settings: JSON file `settings.json` in the same directory. Currently supports `defaultBreakLabel`.

Typical locations:

- macOS: `~/Library/Application Support/`
- Linux: `~/.local/share/`
- Windows: `%APPDATA%` (Roaming)

## Tech stack

- Flutter, Material 3 themes
- State management: Riverpod
- Persistence: Drift (SQLite)
- Desktop integrations: `tray_manager`, `window_manager`
- Assets: SVG icons for tray and actions

## Development

Common commands:

```bash
flutter pub get
dart run build_runner watch --delete-conflicting-outputs
flutter run -d macos   # or your target device
flutter test
```

Project entry point: `lib/main.dart`

Key modules:

- `lib/app/` – app shell, providers, tray/menu integration
- `lib/features/` – UI and view models (tracking, home/quick actions)
- `lib/data/` – Drift database and DAOs
- `lib/core/` – utilities (CSV export, window utils)

## License

MIT (see `LICENSE` if present). If absent, treat as all rights reserved until a license is added.
