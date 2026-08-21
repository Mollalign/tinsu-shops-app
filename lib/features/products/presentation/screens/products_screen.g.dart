// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerProductsHash() => r'0139c13156ebf2e7bb6d69fcdc10fea60cf26644';

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

/// See also [ownerProducts].
@ProviderFor(ownerProducts)
const ownerProductsProvider = OwnerProductsFamily();

/// See also [ownerProducts].
class OwnerProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [ownerProducts].
  const OwnerProductsFamily();

  /// See also [ownerProducts].
  OwnerProductsProvider call(String shopId) {
    return OwnerProductsProvider(shopId);
  }

  @override
  OwnerProductsProvider getProviderOverride(
    covariant OwnerProductsProvider provider,
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
  String? get name => r'ownerProductsProvider';
}

/// See also [ownerProducts].
class OwnerProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [ownerProducts].
  OwnerProductsProvider(String shopId)
    : this._internal(
        (ref) => ownerProducts(ref as OwnerProductsRef, shopId),
        from: ownerProductsProvider,
        name: r'ownerProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$ownerProductsHash,
        dependencies: OwnerProductsFamily._dependencies,
        allTransitiveDependencies:
            OwnerProductsFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  OwnerProductsProvider._internal(
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
    FutureOr<List<ProductModel>> Function(OwnerProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnerProductsProvider._internal(
        (ref) => create(ref as OwnerProductsRef),
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
    return _OwnerProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerProductsProvider && other.shopId == shopId;
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
mixin OwnerProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _OwnerProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with OwnerProductsRef {
  _OwnerProductsProviderElement(super.provider);

  @override
  String get shopId => (origin as OwnerProductsProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
