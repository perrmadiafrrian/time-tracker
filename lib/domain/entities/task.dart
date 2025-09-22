import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_tracker/core/json_converters.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String name,
    String? description,
    @Default(false) bool isArchived,
    @DateTimeIso8601Converter() required DateTime createdAt,
    @DateTimeIso8601Converter() required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
