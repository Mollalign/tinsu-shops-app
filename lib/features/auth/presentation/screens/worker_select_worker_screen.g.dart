// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_select_worker_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopWorkersHash() => r'b929457f18de001c1680800fd970f576f0ed2a71';

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

/// See also [shopWorkers].
@ProviderFor(shopWorkers)
const shopWorkersProvider = ShopWorkersFamily();

/// See also [shopWorkers].
class ShopWorkersFamily extends Family<AsyncValue<List<WorkerModel>>> {
  /// See also [shopWorkers].
  const ShopWorkersFamily();

  /// See also [shopWorkers].
  ShopWorkersProvider call(String shopId) {
    return ShopWorkersProvider(shopId);
  }

  @override
  ShopWorkersProvider getProviderOverride(
    covariant ShopWorkersProvider provider,
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
  String? get name => r'shopWorkersProvider';
}

/// See also [shopWorkers].
class ShopWorkersProvider extends AutoDisposeFutureProvider<List<WorkerModel>> {
  /// See also [shopWorkers].
  ShopWorkersProvider(String shopId)
    : this._internal(
        (ref) => shopWorkers(ref as ShopWorkersRef, shopId),
        from: shopWorkersProvider,
        name: r'shopWorkersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopWorkersHash,
        dependencies: ShopWorkersFamily._dependencies,
        allTransitiveDependencies: ShopWorkersFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopWorkersProvider._internal(
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
    FutureOr<List<WorkerModel>> Function(ShopWorkersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopWorkersProvider._internal(
        (ref) => create(ref as ShopWorkersRef),
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
    return _ShopWorkersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopWorkersProvider && other.shopId == shopId;
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
mixin ShopWorkersRef on AutoDisposeFutureProviderRef<List<WorkerModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopWorkersProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkerModel>>
    with ShopWorkersRef {
  _ShopWorkersProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopWorkersProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
