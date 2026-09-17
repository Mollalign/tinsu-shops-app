// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_analytics_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopStockAnalyticsHash() =>
    r'c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0';

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

/// See also [shopStockAnalytics].
@ProviderFor(shopStockAnalytics)
const shopStockAnalyticsProvider = ShopStockAnalyticsFamily();

/// See also [shopStockAnalytics].
class ShopStockAnalyticsFamily extends Family<AsyncValue<StockAnalytics>> {
  /// See also [shopStockAnalytics].
  const ShopStockAnalyticsFamily();

  /// See also [shopStockAnalytics].
  ShopStockAnalyticsProvider call(
    String shopId,
    AnalyticsPeriod period,
    String date,
  ) {
    return ShopStockAnalyticsProvider(shopId, period, date);
  }

  @override
  ShopStockAnalyticsProvider getProviderOverride(
    covariant ShopStockAnalyticsProvider provider,
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
  String? get name => r'shopStockAnalyticsProvider';
}

/// See also [shopStockAnalytics].
class ShopStockAnalyticsProvider
    extends AutoDisposeFutureProvider<StockAnalytics> {
  /// See also [shopStockAnalytics].
  ShopStockAnalyticsProvider(
    String shopId,
    AnalyticsPeriod period,
    String date,
  ) : this._internal(
          (ref) => shopStockAnalytics(
            ref as ShopStockAnalyticsRef,
            shopId,
            period,
            date,
          ),
          from: shopStockAnalyticsProvider,
          name: r'shopStockAnalyticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shopStockAnalyticsHash,
          dependencies: ShopStockAnalyticsFamily._dependencies,
          allTransitiveDependencies:
              ShopStockAnalyticsFamily._allTransitiveDependencies,
          shopId: shopId,
          period: period,
          date: date,
        );

  ShopStockAnalyticsProvider._internal(
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
    FutureOr<StockAnalytics> Function(ShopStockAnalyticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopStockAnalyticsProvider._internal(
        (ref) => create(ref as ShopStockAnalyticsRef),
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
  AutoDisposeFutureProviderElement<StockAnalytics> createElement() {
    return _ShopStockAnalyticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopStockAnalyticsProvider &&
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
mixin ShopStockAnalyticsRef on AutoDisposeFutureProviderRef<StockAnalytics> {
  /// The class holding the arguments of [shopStockAnalytics].
  String get shopId;

  /// The class holding the arguments of [shopStockAnalytics].
  AnalyticsPeriod get period;

  /// The class holding the arguments of [shopStockAnalytics].
  String get date;
}

class _ShopStockAnalyticsProviderElement
    extends AutoDisposeFutureProviderElement<StockAnalytics>
    with ShopStockAnalyticsRef {
  _ShopStockAnalyticsProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopStockAnalyticsProvider).shopId;
  @override
  AnalyticsPeriod get period => (origin as ShopStockAnalyticsProvider).period;
  @override
  String get date => (origin as ShopStockAnalyticsProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
