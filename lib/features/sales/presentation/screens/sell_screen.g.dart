// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopProductsHash() => r'5d288ce114d35c7d8537e8441fc7fc5d382fe449';

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

/// See also [shopProducts].
@ProviderFor(shopProducts)
const shopProductsProvider = ShopProductsFamily();

/// See also [shopProducts].
class ShopProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [shopProducts].
  const ShopProductsFamily();

  /// See also [shopProducts].
  ShopProductsProvider call(String shopId) {
    return ShopProductsProvider(shopId);
  }

  @override
  ShopProductsProvider getProviderOverride(
    covariant ShopProductsProvider provider,
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
  String? get name => r'shopProductsProvider';
}

/// See also [shopProducts].
class ShopProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [shopProducts].
  ShopProductsProvider(String shopId)
    : this._internal(
        (ref) => shopProducts(ref as ShopProductsRef, shopId),
        from: shopProductsProvider,
        name: r'shopProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopProductsHash,
        dependencies: ShopProductsFamily._dependencies,
        allTransitiveDependencies:
            ShopProductsFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopProductsProvider._internal(
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
    FutureOr<List<ProductModel>> Function(ShopProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopProductsProvider._internal(
        (ref) => create(ref as ShopProductsRef),
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
    return _ShopProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopProductsProvider && other.shopId == shopId;
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
mixin ShopProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ShopProductsRef {
  _ShopProductsProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopProductsProvider).shopId;
}

String _$productSearchHash() => r'7917e3032172acee2ffc3c795bfee0a41891fe22';

/// See also [productSearch].
@ProviderFor(productSearch)
const productSearchProvider = ProductSearchFamily();

/// See also [productSearch].
class ProductSearchFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [productSearch].
  const ProductSearchFamily();

  /// See also [productSearch].
  ProductSearchProvider call(String shopId, String query) {
    return ProductSearchProvider(shopId, query);
  }

  @override
  ProductSearchProvider getProviderOverride(
    covariant ProductSearchProvider provider,
  ) {
    return call(provider.shopId, provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productSearchProvider';
}

/// See also [productSearch].
class ProductSearchProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [productSearch].
  ProductSearchProvider(String shopId, String query)
    : this._internal(
        (ref) => productSearch(ref as ProductSearchRef, shopId, query),
        from: productSearchProvider,
        name: r'productSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$productSearchHash,
        dependencies: ProductSearchFamily._dependencies,
        allTransitiveDependencies:
            ProductSearchFamily._allTransitiveDependencies,
        shopId: shopId,
        query: query,
      );

  ProductSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.query,
  }) : super.internal();

  final String shopId;
  final String query;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(ProductSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductSearchProvider._internal(
        (ref) => create(ref as ProductSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _ProductSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSearchProvider &&
        other.shopId == shopId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductSearchRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `query` of this provider.
  String get query;
}

class _ProductSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ProductSearchRef {
  _ProductSearchProviderElement(super.provider);

  @override
  String get shopId => (origin as ProductSearchProvider).shopId;
  @override
  String get query => (origin as ProductSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
