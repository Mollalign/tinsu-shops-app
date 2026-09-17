// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_history_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productMovementsHash() => r'b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1';

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

/// See also [productMovements].
@ProviderFor(productMovements)
const productMovementsProvider = ProductMovementsFamily();

/// See also [productMovements].
class ProductMovementsFamily
    extends Family<AsyncValue<PagedResult<InventoryMovementModel>>> {
  /// See also [productMovements].
  const ProductMovementsFamily();

  /// See also [productMovements].
  ProductMovementsProvider call(String shopId, String productId) {
    return ProductMovementsProvider(shopId, productId);
  }

  @override
  ProductMovementsProvider getProviderOverride(
    covariant ProductMovementsProvider provider,
  ) {
    return call(provider.shopId, provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productMovementsProvider';
}

/// See also [productMovements].
class ProductMovementsProvider
    extends AutoDisposeFutureProvider<PagedResult<InventoryMovementModel>> {
  /// See also [productMovements].
  ProductMovementsProvider(String shopId, String productId)
    : this._internal(
        (ref) => productMovements(
            ref as ProductMovementsRef, shopId, productId),
        from: productMovementsProvider,
        name: r'productMovementsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productMovementsHash,
        dependencies: ProductMovementsFamily._dependencies,
        allTransitiveDependencies:
            ProductMovementsFamily._allTransitiveDependencies,
        shopId: shopId,
        productId: productId,
      );

  ProductMovementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.productId,
  }) : super.internal();

  final String shopId;
  final String productId;

  @override
  Override overrideWith(
    FutureOr<PagedResult<InventoryMovementModel>> Function(
            ProductMovementsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductMovementsProvider._internal(
        (ref) => create(ref as ProductMovementsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PagedResult<InventoryMovementModel>>
      createElement() {
    return _ProductMovementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductMovementsProvider &&
        other.shopId == shopId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductMovementsRef
    on AutoDisposeFutureProviderRef<PagedResult<InventoryMovementModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductMovementsProviderElement
    extends AutoDisposeFutureProviderElement<PagedResult<InventoryMovementModel>>
    with ProductMovementsRef {
  _ProductMovementsProviderElement(super.provider);

  @override
  String get shopId => (origin as ProductMovementsProvider).shopId;
  @override
  String get productId => (origin as ProductMovementsProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
