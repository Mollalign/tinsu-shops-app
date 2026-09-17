// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_analytics_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopAnalyticsHash() => r'ea52784a72fcccb730fc1048e237ba65ca3bd4a3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [shopAnalytics].
@ProviderFor(shopAnalytics)
const shopAnalyticsProvider = ShopAnalyticsFamily();

/// See also [shopAnalytics].
class ShopAnalyticsFamily extends Family<AsyncValue<SalesAnalytics>> {
  /// See also [shopAnalytics].
  const ShopAnalyticsFamily();

  /// See also [shopAnalytics].
  ShopAnalyticsProvider call(
    String shopId,
    AnalyticsPeriod period,
    String date,
  ) {
    return ShopAnalyticsProvider(shopId, period, date);
  }

  @override
  ShopAnalyticsProvider getProviderOverride(
    covariant ShopAnalyticsProvider provider,
  ) {
    return call(provider.shopId, provider.period, provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shopAnalyticsProvider';
}

/// See also [shopAnalytics].
class ShopAnalyticsProvider extends AutoDisposeFutureProvider<SalesAnalytics> {
  /// See also [shopAnalytics].
  ShopAnalyticsProvider(String shopId, AnalyticsPeriod period, String date)
    : this._internal(
        (ref) => shopAnalytics(ref as ShopAnalyticsRef, shopId, period, date),
        from: shopAnalyticsProvider,
        name: r'shopAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopAnalyticsHash,
        dependencies: ShopAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            ShopAnalyticsFamily._allTransitiveDependencies,
        shopId: shopId,
        period: period,
        date: date,
      );

  ShopAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.period,
    required this.date,
  }) : super.internal();

  final String shopId;
  final AnalyticsPeriod period;
  final String date;

  @override
  Override overrideWith(
    FutureOr<SalesAnalytics> Function(ShopAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopAnalyticsProvider._internal(
        (ref) => create(ref as ShopAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        period: period,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SalesAnalytics> createElement() {
    return _ShopAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopAnalyticsProvider &&
        other.shopId == shopId &&
        other.period == period &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopAnalyticsRef on AutoDisposeFutureProviderRef<SalesAnalytics> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `period` of this provider.
  AnalyticsPeriod get period;

  /// The parameter `date` of this provider.
  String get date;
}

class _ShopAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<SalesAnalytics>
    with ShopAnalyticsRef {
  _ShopAnalyticsProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopAnalyticsProvider).shopId;
  @override
  AnalyticsPeriod get period => (origin as ShopAnalyticsProvider).period;
  @override
  String get date => (origin as ShopAnalyticsProvider).date;
}

String _$shopWorkerAnalyticsHash() =>
    r'b3b853cb000ed7cc3450bf1d85f5d26fd2d13011';

/// See also [shopWorkerAnalytics].
@ProviderFor(shopWorkerAnalytics)
const shopWorkerAnalyticsProvider = ShopWorkerAnalyticsFamily();

/// See also [shopWorkerAnalytics].
class ShopWorkerAnalyticsFamily extends Family<AsyncValue<WorkerAnalytics>> {
  /// See also [shopWorkerAnalytics].
  const ShopWorkerAnalyticsFamily();

  /// See also [shopWorkerAnalytics].
  ShopWorkerAnalyticsProvider call(
    String shopId,
    String startDate,
    String endDate,
  ) {
    return ShopWorkerAnalyticsProvider(shopId, startDate, endDate);
  }

  @override
  ShopWorkerAnalyticsProvider getProviderOverride(
    covariant ShopWorkerAnalyticsProvider provider,
  ) {
    return call(provider.shopId, provider.startDate, provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shopWorkerAnalyticsProvider';
}

/// See also [shopWorkerAnalytics].
class ShopWorkerAnalyticsProvider
    extends AutoDisposeFutureProvider<WorkerAnalytics> {
  /// See also [shopWorkerAnalytics].
  ShopWorkerAnalyticsProvider(String shopId, String startDate, String endDate)
    : this._internal(
        (ref) => shopWorkerAnalytics(
          ref as ShopWorkerAnalyticsRef,
          shopId,
          startDate,
          endDate,
        ),
        from: shopWorkerAnalyticsProvider,
        name: r'shopWorkerAnalyticsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopWorkerAnalyticsHash,
        dependencies: ShopWorkerAnalyticsFamily._dependencies,
        allTransitiveDependencies:
            ShopWorkerAnalyticsFamily._allTransitiveDependencies,
        shopId: shopId,
        startDate: startDate,
        endDate: endDate,
      );

  ShopWorkerAnalyticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String shopId;
  final String startDate;
  final String endDate;

  @override
  Override overrideWith(
    FutureOr<WorkerAnalytics> Function(ShopWorkerAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopWorkerAnalyticsProvider._internal(
        (ref) => create(ref as ShopWorkerAnalyticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkerAnalytics> createElement() {
    return _ShopWorkerAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopWorkerAnalyticsProvider &&
        other.shopId == shopId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopWorkerAnalyticsRef on AutoDisposeFutureProviderRef<WorkerAnalytics> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `startDate` of this provider.
  String get startDate;

  /// The parameter `endDate` of this provider.
  String get endDate;
}

class _ShopWorkerAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<WorkerAnalytics>
    with ShopWorkerAnalyticsRef {
  _ShopWorkerAnalyticsProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopWorkerAnalyticsProvider).shopId;
  @override
  String get startDate => (origin as ShopWorkerAnalyticsProvider).startDate;
  @override
  String get endDate => (origin as ShopWorkerAnalyticsProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
