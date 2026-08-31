// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopCategoriesHash() => r'1b102a56d4bb8a457bb7bd94b5dabedb50cd6745';

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

/// See also [shopCategories].
@ProviderFor(shopCategories)
const shopCategoriesProvider = ShopCategoriesFamily();

/// See also [shopCategories].
class ShopCategoriesFamily extends Family<AsyncValue<List<CategoryModel>>> {
  /// See also [shopCategories].
  const ShopCategoriesFamily();

  /// See also [shopCategories].
  ShopCategoriesProvider call(String shopId) {
    return ShopCategoriesProvider(shopId);
  }

  @override
  ShopCategoriesProvider getProviderOverride(
    covariant ShopCategoriesProvider provider,
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
  String? get name => r'shopCategoriesProvider';
}

/// See also [shopCategories].
class ShopCategoriesProvider
    extends AutoDisposeFutureProvider<List<CategoryModel>> {
  /// See also [shopCategories].
  ShopCategoriesProvider(String shopId)
    : this._internal(
        (ref) => shopCategories(ref as ShopCategoriesRef, shopId),
        from: shopCategoriesProvider,
        name: r'shopCategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopCategoriesHash,
        dependencies: ShopCategoriesFamily._dependencies,
        allTransitiveDependencies:
            ShopCategoriesFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopCategoriesProvider._internal(
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
    FutureOr<List<CategoryModel>> Function(ShopCategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopCategoriesProvider._internal(
        (ref) => create(ref as ShopCategoriesRef),
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
  AutoDisposeFutureProviderElement<List<CategoryModel>> createElement() {
    return _ShopCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopCategoriesProvider && other.shopId == shopId;
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
mixin ShopCategoriesRef on AutoDisposeFutureProviderRef<List<CategoryModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryModel>>
    with ShopCategoriesRef {
  _ShopCategoriesProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopCategoriesProvider).shopId;
}

String _$shopProductsHash() => r'ec9ed6b662eec81e5c96c9730a38e66a8ed0df9a';

/// See also [shopProducts].
@ProviderFor(shopProducts)
const shopProductsProvider = ShopProductsFamily();

/// See also [shopProducts].
class ShopProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [shopProducts].
  const ShopProductsFamily();

  /// See also [shopProducts].
  ShopProductsProvider call(String shopId, {String? categoryId}) {
    return ShopProductsProvider(shopId, categoryId: categoryId);
  }

  @override
  ShopProductsProvider getProviderOverride(
    covariant ShopProductsProvider provider,
  ) {
    return call(provider.shopId, categoryId: provider.categoryId);
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
  ShopProductsProvider(String shopId, {String? categoryId})
    : this._internal(
        (ref) => shopProducts(
          ref as ShopProductsRef,
          shopId,
          categoryId: categoryId,
        ),
        from: shopProductsProvider,
        name: r'shopProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopProductsHash,
        dependencies: ShopProductsFamily._dependencies,
        allTransitiveDependencies:
            ShopProductsFamily._allTransitiveDependencies,
        shopId: shopId,
        categoryId: categoryId,
      );

  ShopProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.categoryId,
  }) : super.internal();

  final String shopId;
  final String? categoryId;

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
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _ShopProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopProductsProvider &&
        other.shopId == shopId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShopProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _ShopProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ShopProductsRef {
  _ShopProductsProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopProductsProvider).shopId;
  @override
  String? get categoryId => (origin as ShopProductsProvider).categoryId;
}

String _$productSearchHash() => r'79164c41d6de514c13e94e303ec88c3e9fc2f554';

/// See also [productSearch].
@ProviderFor(productSearch)
const productSearchProvider = ProductSearchFamily();

/// See also [productSearch].
class ProductSearchFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [productSearch].
  const ProductSearchFamily();

  /// See also [productSearch].
  ProductSearchProvider call(
    String shopId,
    String query, {
    String? categoryId,
  }) {
    return ProductSearchProvider(shopId, query, categoryId: categoryId);
  }

  @override
  ProductSearchProvider getProviderOverride(
    covariant ProductSearchProvider provider,
  ) {
    return call(
      provider.shopId,
      provider.query,
      categoryId: provider.categoryId,
    );
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
  ProductSearchProvider(String shopId, String query, {String? categoryId})
    : this._internal(
        (ref) => productSearch(
          ref as ProductSearchRef,
          shopId,
          query,
          categoryId: categoryId,
        ),
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
        categoryId: categoryId,
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
    required this.categoryId,
  }) : super.internal();

  final String shopId;
  final String query;
  final String? categoryId;

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
        categoryId: categoryId,
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
        other.query == query &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

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

  /// The parameter `categoryId` of this provider.
  String? get categoryId;
}

class _ProductSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with ProductSearchRef {
  _ProductSearchProviderElement(super.provider);

  @override
  String get shopId => (origin as ProductSearchProvider).shopId;
  @override
  String get query => (origin as ProductSearchProvider).query;
  @override
  String? get categoryId => (origin as ProductSearchProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
