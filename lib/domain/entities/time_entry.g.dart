// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeEntryImpl _$$TimeEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimeEntryImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      start: const DateTimeIso8601Converter().fromJson(json['start'] as String),
      end: const NullableDateTimeIso8601Converter().fromJson(
        json['end'] as String?,
      ),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$TimeEntryImplToJson(_$TimeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'start': const DateTimeIso8601Converter().toJson(instance.start),
      'end': const NullableDateTimeIso8601Converter().toJson(instance.end),
      'note': instance.note,
    };
