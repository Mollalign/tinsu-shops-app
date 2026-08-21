// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_history_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopSalesHash() => r'87d1e40fbfd31a9b260aa4014c0664f471ab4f7f';

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

/// See also [shopSales].
@ProviderFor(shopSales)
const shopSalesProvider = ShopSalesFamily();

/// See also [shopSales].
class ShopSalesFamily extends Family<AsyncValue<List<SaleListItem>>> {
  /// See also [shopSales].
  const ShopSalesFamily();

  /// See also [shopSales].
  ShopSalesProvider call(String shopId) {
    return ShopSalesProvider(shopId);
  }

  @override
  ShopSalesProvider getProviderOverride(covariant ShopSalesProvider provider) {
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
  String? get name => r'shopSalesProvider';
}

/// See also [shopSales].
class ShopSalesProvider extends AutoDisposeFutureProvider<List<SaleListItem>> {
  /// See also [shopSales].
  ShopSalesProvider(String shopId)
    : this._internal(
        (ref) => shopSales(ref as ShopSalesRef, shopId),
        from: shopSalesProvider,
        name: r'shopSalesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopSalesHash,
        dependencies: ShopSalesFamily._dependencies,
        allTransitiveDependencies: ShopSalesFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  ShopSalesProvider._internal(
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
    FutureOr<List<SaleListItem>> Function(ShopSalesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShopSalesProvider._internal(
        (ref) => create(ref as ShopSalesRef),
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
    return _ShopSalesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopSalesProvider && other.shopId == shopId;
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
mixin ShopSalesRef on AutoDisposeFutureProviderRef<List<SaleListItem>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _ShopSalesProviderElement
    extends AutoDisposeFutureProviderElement<List<SaleListItem>>
    with ShopSalesRef {
  _ShopSalesProviderElement(super.provider);

  @override
  String get shopId => (origin as ShopSalesProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
