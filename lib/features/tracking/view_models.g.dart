// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_models.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeEntryHash() => r'211c103c0bf0c8139d37641f28315d3b17f99d69';

/// See also [activeEntry].
@ProviderFor(activeEntry)
final activeEntryProvider = AutoDisposeStreamProvider<TimeEntry?>.internal(
  activeEntry,
  name: r'activeEntryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeEntryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveEntryRef = AutoDisposeStreamProviderRef<TimeEntry?>;
String _$todayEntriesHash() => r'ee8a68f29ea928a7f5fdacec8f2dca6b7a7ca177';

/// See also [todayEntries].
@ProviderFor(todayEntries)
final todayEntriesProvider =
    AutoDisposeStreamProvider<List<domain.TimeEntry>>.internal(
      todayEntries,
      name: r'todayEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayEntriesRef = AutoDisposeStreamProviderRef<List<domain.TimeEntry>>;
String _$dailySummaryHash() => r'2ca2c914cd1ba74530cefb5dfe151978c9a8564c';

/// See also [dailySummary].
@ProviderFor(dailySummary)
final dailySummaryProvider =
    AutoDisposeStreamProvider<domain.DailySummary>.internal(
      dailySummary,
      name: r'dailySummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailySummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailySummaryRef = AutoDisposeStreamProviderRef<domain.DailySummary>;
String _$trackingViewModelHash() => r'31ee979baf9ea462e3a5a8f78941f6ee7367bfb5';

/// See also [TrackingViewModel].
@ProviderFor(TrackingViewModel)
final trackingViewModelProvider =
    AutoDisposeNotifierProvider<TrackingViewModel, TrackingState>.internal(
      TrackingViewModel.new,
      name: r'trackingViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$trackingViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TrackingViewModel = AutoDisposeNotifier<TrackingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
