// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopHomeSummaryHash() => r'f390a3e59302d449c9c2e82a44ab7bc021a3653d';

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

/// See also [shopHomeSummary].
@ProviderFor(shopHomeSummary)
const shopHomeSummaryProvider = ShopHomeSummaryFamily();

/// See also [shopHomeSummary].
class ShopHomeSummaryFamily extends Family<AsyncValue<HomeSummary>> {
  /// See also [shopHomeSummary].
  const ShopHomeSummaryFamily();

  /// See also [shopHomeSummary].
  ShopHomeSummaryProvider call(String shopId) {
    return ShopHomeSummaryProvider(shopId);
  }

  @override
  ShopHomeSummaryProvider getProviderOverride(
    covariant ShopHomeSummaryProvider provider,
  ) {
    return call(provider.shopId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shopHomeSummaryProvider';
}

/// See also [shopHomeSummary].
class ShopHomeSummaryProvider extends AutoDisposeFutureProvider<HomeSummary> {
  /// See also [shopHomeSummary].
  ShopHomeSummaryProvider(String shopId)
    : this._internal(
        (ref) => shopHomeSummary(ref as ShopHomeSummaryRef, shopId),
        from: shopHomeSummaryProvider,
        name: r'shopHomeSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopHomeSummaryHash,
        dependencies: ShopHomeSummaryFamily._dependencies,
        allTransitiveDependencies:
            ShopHomeSummaryFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopHomeSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
  }) : super.internal();

  final String shopId;

  @override
  Override overrideWith(
    FutureOr<HomeSummary> Function(ShopHomeSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopHomeSummaryProvider._internal(
        (ref) => create(ref as ShopHomeSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HomeSummary> createElement() {
    return _ShopHomeSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopHomeSummaryProvider && other.shopId == shopId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopHomeSummaryRef on AutoDisposeFutureProviderRef<HomeSummary> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopHomeSummaryProviderElement
    extends AutoDisposeFutureProviderElement<HomeSummary>
    with ShopHomeSummaryRef {
  _ShopHomeSummaryProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopHomeSummaryProvider).shopId;
}

String _$shopTodayReportHash() => r'122c54f36e10440d9e637d406707fed993b002e7';

/// See also [shopTodayReport].
@ProviderFor(shopTodayReport)
const shopTodayReportProvider = ShopTodayReportFamily();

/// See also [shopTodayReport].
class ShopTodayReportFamily extends Family<AsyncValue<TodayReport>> {
  /// See also [shopTodayReport].
  const ShopTodayReportFamily();

  /// See also [shopTodayReport].
  ShopTodayReportProvider call(String shopId) {
    return ShopTodayReportProvider(shopId);
  }

  @override
  ShopTodayReportProvider getProviderOverride(
    covariant ShopTodayReportProvider provider,
  ) {
    return call(provider.shopId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shopTodayReportProvider';
}

/// See also [shopTodayReport].
class ShopTodayReportProvider extends AutoDisposeFutureProvider<TodayReport> {
  /// See also [shopTodayReport].
  ShopTodayReportProvider(String shopId)
    : this._internal(
        (ref) => shopTodayReport(ref as ShopTodayReportRef, shopId),
        from: shopTodayReportProvider,
        name: r'shopTodayReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopTodayReportHash,
        dependencies: ShopTodayReportFamily._dependencies,
        allTransitiveDependencies:
            ShopTodayReportFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopTodayReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
  }) : super.internal();

  final String shopId;

  @override
  Override overrideWith(
    FutureOr<TodayReport> Function(ShopTodayReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopTodayReportProvider._internal(
        (ref) => create(ref as ShopTodayReportRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TodayReport> createElement() {
    return _ShopTodayReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopTodayReportProvider && other.shopId == shopId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopTodayReportRef on AutoDisposeFutureProviderRef<TodayReport> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopTodayReportProviderElement
    extends AutoDisposeFutureProviderElement<TodayReport>
    with ShopTodayReportRef {
  _ShopTodayReportProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopTodayReportProvider).shopId;
}

String _$dashboardLowStockHash() => r'bc309176efd2a151555d387529c32808c1bf724f';

/// See also [dashboardLowStock].
@ProviderFor(dashboardLowStock)
const dashboardLowStockProvider = DashboardLowStockFamily();

/// See also [dashboardLowStock].
class DashboardLowStockFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [dashboardLowStock].
  const DashboardLowStockFamily();

  /// See also [dashboardLowStock].
  DashboardLowStockProvider call(String shopId) {
    return DashboardLowStockProvider(shopId);
  }

  @override
  DashboardLowStockProvider getProviderOverride(
    covariant DashboardLowStockProvider provider,
  ) {
    return call(provider.shopId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardLowStockProvider';
}

/// See also [dashboardLowStock].
class DashboardLowStockProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [dashboardLowStock].
  DashboardLowStockProvider(String shopId)
    : this._internal(
        (ref) => dashboardLowStock(ref as DashboardLowStockRef, shopId),
        from: dashboardLowStockProvider,
        name: r'dashboardLowStockProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardLowStockHash,
        dependencies: DashboardLowStockFamily._dependencies,
        allTransitiveDependencies:
            DashboardLowStockFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  DashboardLowStockProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
  }) : super.internal();

  final String shopId;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(DashboardLowStockRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardLowStockProvider._internal(
        (ref) => create(ref as DashboardLowStockRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _DashboardLowStockProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardLowStockProvider && other.shopId == shopId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardLowStockRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _DashboardLowStockProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with DashboardLowStockRef {
  _DashboardLowStockProviderElement(super.provider);

  @override
  String get shopId => (origin as DashboardLowStockProvider).shopId;
}

String _$dashboardWorkersHash() => r'059b980ce52a5372883843dbbc0fd9176c1d390f';

/// See also [dashboardWorkers].
@ProviderFor(dashboardWorkers)
const dashboardWorkersProvider = DashboardWorkersFamily();

/// See also [dashboardWorkers].
class DashboardWorkersFamily extends Family<AsyncValue<List<WorkerModel>>> {
  /// See also [dashboardWorkers].
  const DashboardWorkersFamily();

  /// See also [dashboardWorkers].
  DashboardWorkersProvider call(String shopId) {
    return DashboardWorkersProvider(shopId);
  }

  @override
  DashboardWorkersProvider getProviderOverride(
    covariant DashboardWorkersProvider provider,
  ) {
    return call(provider.shopId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dashboardWorkersProvider';
}

/// See also [dashboardWorkers].
class DashboardWorkersProvider
    extends AutoDisposeFutureProvider<List<WorkerModel>> {
  /// See also [dashboardWorkers].
  DashboardWorkersProvider(String shopId)
    : this._internal(
        (ref) => dashboardWorkers(ref as DashboardWorkersRef, shopId),
        from: dashboardWorkersProvider,
        name: r'dashboardWorkersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dashboardWorkersHash,
        dependencies: DashboardWorkersFamily._dependencies,
        allTransitiveDependencies:
            DashboardWorkersFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  DashboardWorkersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
  }) : super.internal();

  final String shopId;

  @override
  Override overrideWith(
    FutureOr<List<WorkerModel>> Function(DashboardWorkersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DashboardWorkersProvider._internal(
        (ref) => create(ref as DashboardWorkersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkerModel>> createElement() {
    return _DashboardWorkersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardWorkersProvider && other.shopId == shopId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DashboardWorkersRef on AutoDisposeFutureProviderRef<List<WorkerModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _DashboardWorkersProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkerModel>>
    with DashboardWorkersRef {
  _DashboardWorkersProviderElement(super.provider);

  @override
  String get shopId => (origin as DashboardWorkersProvider).shopId;
}

String _$dashboardShopsHash() => r'02a4e6556bb03d59e92e13d00f6dd8d9e532f8ee';

/// See also [dashboardShops].
@ProviderFor(dashboardShops)
final dashboardShopsProvider =
    AutoDisposeFutureProvider<List<ShopModel>>.internal(
      dashboardShops,
      name: r'dashboardShopsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardShopsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardShopsRef = AutoDisposeFutureProviderRef<List<ShopModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
