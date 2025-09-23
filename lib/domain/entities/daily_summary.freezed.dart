// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailySummary _$DailySummaryFromJson(Map<String, dynamic> json) {
  return _DailySummary.fromJson(json);
}

/// @nodoc
mixin _$DailySummary {
  /// Date at midnight UTC for the day represented
  @DateTimeIso8601Converter()
  DateTime get date => throw _privateConstructorUsedError;
  @DurationSecondsConverter()
  Duration get totalDuration => throw _privateConstructorUsedError;
  @DurationSecondsValueMapConverter()
  Map<String, Duration> get taskDurations => throw _privateConstructorUsedError;

  /// Serializes this DailySummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailySummaryCopyWith<DailySummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailySummaryCopyWith<$Res> {
  factory $DailySummaryCopyWith(
    DailySummary value,
    $Res Function(DailySummary) then,
  ) = _$DailySummaryCopyWithImpl<$Res, DailySummary>;
  @useResult
  $Res call({
    @DateTimeIso8601Converter() DateTime date,
    @DurationSecondsConverter() Duration totalDuration,
    @DurationSecondsValueMapConverter() Map<String, Duration> taskDurations,
  });
}

/// @nodoc
class _$DailySummaryCopyWithImpl<$Res, $Val extends DailySummary>
    implements $DailySummaryCopyWith<$Res> {
  _$DailySummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalDuration = null,
    Object? taskDurations = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalDuration: null == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            taskDurations: null == taskDurations
                ? _value.taskDurations
                : taskDurations // ignore: cast_nullable_to_non_nullable
                      as Map<String, Duration>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailySummaryImplCopyWith<$Res>
    implements $DailySummaryCopyWith<$Res> {
  factory _$$DailySummaryImplCopyWith(
    _$DailySummaryImpl value,
    $Res Function(_$DailySummaryImpl) then,
  ) = __$$DailySummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @DateTimeIso8601Converter() DateTime date,
    @DurationSecondsConverter() Duration totalDuration,
    @DurationSecondsValueMapConverter() Map<String, Duration> taskDurations,
  });
}

/// @nodoc
class __$$DailySummaryImplCopyWithImpl<$Res>
    extends _$DailySummaryCopyWithImpl<$Res, _$DailySummaryImpl>
    implements _$$DailySummaryImplCopyWith<$Res> {
  __$$DailySummaryImplCopyWithImpl(
    _$DailySummaryImpl _value,
    $Res Function(_$DailySummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalDuration = null,
    Object? taskDurations = null,
  }) {
    return _then(
      _$DailySummaryImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalDuration: null == totalDuration
            ? _value.totalDuration
            : totalDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        taskDurations: null == taskDurations
            ? _value._taskDurations
            : taskDurations // ignore: cast_nullable_to_non_nullable
                  as Map<String, Duration>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailySummaryImpl implements _DailySummary {
  const _$DailySummaryImpl({
    @DateTimeIso8601Converter() required this.date,
    @DurationSecondsConverter() required this.totalDuration,
    @DurationSecondsValueMapConverter()
    required final Map<String, Duration> taskDurations,
  }) : _taskDurations = taskDurations;

  factory _$DailySummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailySummaryImplFromJson(json);

  /// Date at midnight UTC for the day represented
  @override
  @DateTimeIso8601Converter()
  final DateTime date;
  @override
  @DurationSecondsConverter()
  final Duration totalDuration;
  final Map<String, Duration> _taskDurations;
  @override
  @DurationSecondsValueMapConverter()
  Map<String, Duration> get taskDurations {
    if (_taskDurations is EqualUnmodifiableMapView) return _taskDurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_taskDurations);
  }

  @override
  String toString() {
    return 'DailySummary(date: $date, totalDuration: $totalDuration, taskDurations: $taskDurations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailySummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            const DeepCollectionEquality().equals(
              other._taskDurations,
              _taskDurations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    totalDuration,
    const DeepCollectionEquality().hash(_taskDurations),
  );

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      __$$DailySummaryImplCopyWithImpl<_$DailySummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailySummaryImplToJson(this);
  }
}

abstract class _DailySummary implements DailySummary {
  const factory _DailySummary({
    @DateTimeIso8601Converter() required final DateTime date,
    @DurationSecondsConverter() required final Duration totalDuration,
    @DurationSecondsValueMapConverter()
    required final Map<String, Duration> taskDurations,
  }) = _$DailySummaryImpl;

  factory _DailySummary.fromJson(Map<String, dynamic> json) =
      _$DailySummaryImpl.fromJson;

  /// Date at midnight UTC for the day represented
  @override
  @DateTimeIso8601Converter()
  DateTime get date;
  @override
  @DurationSecondsConverter()
  Duration get totalDuration;
  @override
  @DurationSecondsValueMapConverter()
  Map<String, Duration> get taskDurations;

  /// Create a copy of DailySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailySummaryImplCopyWith<_$DailySummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
