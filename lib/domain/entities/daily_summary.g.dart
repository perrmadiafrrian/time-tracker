// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailySummaryImpl _$$DailySummaryImplFromJson(Map<String, dynamic> json) =>
    _$DailySummaryImpl(
      date: const DateTimeIso8601Converter().fromJson(json['date'] as String),
      totalDuration: const DurationSecondsConverter().fromJson(
        (json['totalDuration'] as num).toInt(),
      ),
      taskDurations: const DurationSecondsValueMapConverter().fromJson(
        json['taskDurations'] as Map<String, int>,
      ),
    );

Map<String, dynamic> _$$DailySummaryImplToJson(_$DailySummaryImpl instance) =>
    <String, dynamic>{
      'date': const DateTimeIso8601Converter().toJson(instance.date),
      'totalDuration': const DurationSecondsConverter().toJson(
        instance.totalDuration,
      ),
      'taskDurations': const DurationSecondsValueMapConverter().toJson(
        instance.taskDurations,
      ),
    };
