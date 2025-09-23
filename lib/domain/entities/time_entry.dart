import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_tracker/core/json_converters.dart';

part 'time_entry.freezed.dart';
part 'time_entry.g.dart';

@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String taskId,
    @DateTimeIso8601Converter() required DateTime start,
    @NullableDateTimeIso8601Converter() DateTime? end,
    String? note,
  }) = _TimeEntry;

  const TimeEntry._();

  /// Computed duration; if [end] is null, returns Duration.zero.
  @DurationSecondsConverter()
  Duration get duration => end == null
      ? Duration.zero
      : end!.difference(start).isNegative
      ? Duration.zero
      : end!.difference(start);

  factory TimeEntry.fromJson(Map<String, dynamic> json) =>
      _$TimeEntryFromJson(json);
}
