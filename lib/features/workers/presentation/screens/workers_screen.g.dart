// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workers_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopWorkersListHash() => r'4bdd22efa174a860ee948a3d9bc8a6e78688965b';

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

/// See also [shopWorkersList].
@ProviderFor(shopWorkersList)
const shopWorkersListProvider = ShopWorkersListFamily();

/// See also [shopWorkersList].
class ShopWorkersListFamily extends Family<AsyncValue<List<WorkerModel>>> {
  /// See also [shopWorkersList].
  const ShopWorkersListFamily();

  /// See also [shopWorkersList].
  ShopWorkersListProvider call(String shopId) {
    return ShopWorkersListProvider(shopId);
  }

  @override
  ShopWorkersListProvider getProviderOverride(
    covariant ShopWorkersListProvider provider,
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
  String? get name => r'shopWorkersListProvider';
}

/// See also [shopWorkersList].
class ShopWorkersListProvider
    extends AutoDisposeFutureProvider<List<WorkerModel>> {
  /// See also [shopWorkersList].
  ShopWorkersListProvider(String shopId)
    : this._internal(
        (ref) => shopWorkersList(ref as ShopWorkersListRef, shopId),
        from: shopWorkersListProvider,
        name: r'shopWorkersListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopWorkersListHash,
        dependencies: ShopWorkersListFamily._dependencies,
        allTransitiveDependencies:
            ShopWorkersListFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopWorkersListProvider._internal(
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
    FutureOr<List<WorkerModel>> Function(ShopWorkersListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopWorkersListProvider._internal(
        (ref) => create(ref as ShopWorkersListRef),
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
    return _ShopWorkersListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopWorkersListProvider && other.shopId == shopId;
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
mixin ShopWorkersListRef on AutoDisposeFutureProviderRef<List<WorkerModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopWorkersListProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkerModel>>
    with ShopWorkersListRef {
  _ShopWorkersListProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopWorkersListProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
