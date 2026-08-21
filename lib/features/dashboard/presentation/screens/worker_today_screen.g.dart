// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_today_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workerTodayReportHash() => r'7825f1abeae521b09a761bed5f146b96434d1d9b';

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

/// See also [workerTodayReport].
@ProviderFor(workerTodayReport)
const workerTodayReportProvider = WorkerTodayReportFamily();

/// See also [workerTodayReport].
class WorkerTodayReportFamily extends Family<AsyncValue<WorkerTodayReport>> {
  /// See also [workerTodayReport].
  const WorkerTodayReportFamily();

  /// See also [workerTodayReport].
  WorkerTodayReportProvider call(String shopId) {
    return WorkerTodayReportProvider(shopId);
  }

  @override
  WorkerTodayReportProvider getProviderOverride(
    covariant WorkerTodayReportProvider provider,
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
  String? get name => r'workerTodayReportProvider';
}

/// See also [workerTodayReport].
class WorkerTodayReportProvider
    extends AutoDisposeFutureProvider<WorkerTodayReport> {
  /// See also [workerTodayReport].
  WorkerTodayReportProvider(String shopId)
    : this._internal(
        (ref) => workerTodayReport(ref as WorkerTodayReportRef, shopId),
        from: workerTodayReportProvider,
        name: r'workerTodayReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workerTodayReportHash,
        dependencies: WorkerTodayReportFamily._dependencies,
        allTransitiveDependencies:
            WorkerTodayReportFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  WorkerTodayReportProvider._internal(
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
    FutureOr<WorkerTodayReport> Function(WorkerTodayReportRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkerTodayReportProvider._internal(
        (ref) => create(ref as WorkerTodayReportRef),
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
  AutoDisposeFutureProviderElement<WorkerTodayReport> createElement() {
    return _WorkerTodayReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkerTodayReportProvider && other.shopId == shopId;
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
mixin WorkerTodayReportRef on AutoDisposeFutureProviderRef<WorkerTodayReport> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _WorkerTodayReportProviderElement
    extends AutoDisposeFutureProviderElement<WorkerTodayReport>
    with WorkerTodayReportRef {
  _WorkerTodayReportProviderElement(super.provider);

  @override
  String get shopId => (origin as WorkerTodayReportProvider).shopId;
}

String _$workerSalesHash() => r'41ab5c53f108b5e3ad2c9374f1aa281a98312376';

/// See also [workerSales].
@ProviderFor(workerSales)
const workerSalesProvider = WorkerSalesFamily();

/// See also [workerSales].
class WorkerSalesFamily extends Family<AsyncValue<List<SaleListItem>>> {
  /// See also [workerSales].
  const WorkerSalesFamily();

  /// See also [workerSales].
  WorkerSalesProvider call(String shopId) {
    return WorkerSalesProvider(shopId);
  }

  @override
  WorkerSalesProvider getProviderOverride(
    covariant WorkerSalesProvider provider,
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
  String? get name => r'workerSalesProvider';
}

/// See also [workerSales].
class WorkerSalesProvider
    extends AutoDisposeFutureProvider<List<SaleListItem>> {
  /// See also [workerSales].
  WorkerSalesProvider(String shopId)
    : this._internal(
        (ref) => workerSales(ref as WorkerSalesRef, shopId),
        from: workerSalesProvider,
        name: r'workerSalesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workerSalesHash,
        dependencies: WorkerSalesFamily._dependencies,
        allTransitiveDependencies: WorkerSalesFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  WorkerSalesProvider._internal(
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
    FutureOr<List<SaleListItem>> Function(WorkerSalesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkerSalesProvider._internal(
        (ref) => create(ref as WorkerSalesRef),
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
  AutoDisposeFutureProviderElement<List<SaleListItem>> createElement() {
    return _WorkerSalesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkerSalesProvider && other.shopId == shopId;
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
mixin WorkerSalesRef on AutoDisposeFutureProviderRef<List<SaleListItem>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _WorkerSalesProviderElement
    extends AutoDisposeFutureProviderElement<List<SaleListItem>>
    with WorkerSalesRef {
  _WorkerSalesProviderElement(super.provider);

  @override
  String get shopId => (origin as WorkerSalesProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
