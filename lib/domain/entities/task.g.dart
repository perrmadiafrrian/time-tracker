// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isArchived: json['isArchived'] as bool? ?? false,
  createdAt: const DateTimeIso8601Converter().fromJson(
    json['createdAt'] as String,
  ),
  updatedAt: const DateTimeIso8601Converter().fromJson(
    json['updatedAt'] as String,
  ),
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isArchived': instance.isArchived,
      'createdAt': const DateTimeIso8601Converter().toJson(instance.createdAt),
      'updatedAt': const DateTimeIso8601Converter().toJson(instance.updatedAt),
    };
