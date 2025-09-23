import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts [DateTime] to/from ISO-8601 strings in UTC.
class DateTimeIso8601Converter implements JsonConverter<DateTime, String> {
  const DateTimeIso8601Converter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toUtc();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Converts nullable [DateTime] to/from ISO-8601 strings in UTC.
class NullableDateTimeIso8601Converter
    implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeIso8601Converter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toUtc();

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

/// Converts [Duration] to/from total seconds (int).
class DurationSecondsConverter implements JsonConverter<Duration, int> {
  const DurationSecondsConverter();

  @override
  Duration fromJson(int json) => Duration(seconds: json);

  @override
  int toJson(Duration object) => object.inSeconds;
}

/// Converts nullable [Duration] to/from total seconds (int).
class NullableDurationSecondsConverter
    implements JsonConverter<Duration?, int?> {
  const NullableDurationSecondsConverter();

  @override
  Duration? fromJson(int? json) =>
      json == null ? null : Duration(seconds: json);

  @override
  int? toJson(Duration? object) => object?.inSeconds;
}

/// Converts a map of durations to a map of seconds.
class DurationSecondsValueMapConverter
    implements JsonConverter<Map<String, Duration>, Map<String, int>> {
  const DurationSecondsValueMapConverter();

  @override
  Map<String, Duration> fromJson(Map<String, int> json) => json.map(
        (key, value) => MapEntry(key, Duration(seconds: value)),
      );

  @override
  Map<String, int> toJson(Map<String, Duration> object) => object.map(
        (key, value) => MapEntry(key, value.inSeconds),
      );
}

