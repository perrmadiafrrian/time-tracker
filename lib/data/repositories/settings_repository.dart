import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class Settings {
  final String defaultBreakLabel;

  const Settings({required this.defaultBreakLabel});

  Settings copyWith({String? defaultBreakLabel}) =>
      Settings(defaultBreakLabel: defaultBreakLabel ?? this.defaultBreakLabel);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'defaultBreakLabel': defaultBreakLabel,
  };

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    defaultBreakLabel:
        (json['defaultBreakLabel'] as String?)?.trim().isNotEmpty == true
        ? json['defaultBreakLabel'] as String
        : 'Break',
  );

  static const Settings defaults = Settings(defaultBreakLabel: 'Break');
}

class SettingsRepository {
  static const String _fileName = 'settings.json';

  Future<File> _file() async {
    final Directory dir = await getApplicationSupportDirectory();
    return File(p.join(dir.path, _fileName));
  }

  Future<Settings> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) {
        return Settings.defaults;
      }
      final String contents = await file.readAsString();
      if (contents.trim().isEmpty) return Settings.defaults;
      final Map<String, dynamic> jsonMap =
          json.decode(contents) as Map<String, dynamic>;
      return Settings.fromJson(jsonMap);
    } catch (_) {
      return Settings.defaults;
    }
  }

  Future<void> save(Settings settings) async {
    final file = await _file();
    try {
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsString(json.encode(settings.toJson()));
    } catch (_) {
      // Swallow errors for now; caller can decide to surface if needed.
    }
  }
}
