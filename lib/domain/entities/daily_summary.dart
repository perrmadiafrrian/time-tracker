import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_tracker/core/json_converters.dart';

part 'daily_summary.freezed.dart';
part 'daily_summary.g.dart';

@freezed
class DailySummary with _$DailySummary {
  const factory DailySummary({
    /// Date at midnight UTC for the day represented
    @DateTimeIso8601Converter() required DateTime date,
    @DurationSecondsConverter() required Duration totalDuration,
    @DurationSecondsValueMapConverter()
    required Map<String, Duration> taskDurations,
  }) = _DailySummary;

  factory DailySummary.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryFromJson(json);
}
