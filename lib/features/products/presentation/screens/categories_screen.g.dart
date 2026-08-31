// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerCategoriesHash() => r'e242a56fbcc35d7cd600564168e5f888ae30dc84';

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

/// See also [ownerCategories].
@ProviderFor(ownerCategories)
const ownerCategoriesProvider = OwnerCategoriesFamily();

/// See also [ownerCategories].
class OwnerCategoriesFamily extends Family<AsyncValue<List<CategoryModel>>> {
  /// See also [ownerCategories].
  const OwnerCategoriesFamily();

  /// See also [ownerCategories].
  OwnerCategoriesProvider call(String shopId) {
    return OwnerCategoriesProvider(shopId);
  }

  @override
  OwnerCategoriesProvider getProviderOverride(
    covariant OwnerCategoriesProvider provider,
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
  String? get name => r'ownerCategoriesProvider';
}

/// See also [ownerCategories].
class OwnerCategoriesProvider
    extends AutoDisposeFutureProvider<List<CategoryModel>> {
  /// See also [ownerCategories].
  OwnerCategoriesProvider(String shopId)
    : this._internal(
        (ref) => ownerCategories(ref as OwnerCategoriesRef, shopId),
        from: ownerCategoriesProvider,
        name: r'ownerCategoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$ownerCategoriesHash,
        dependencies: OwnerCategoriesFamily._dependencies,
        allTransitiveDependencies:
            OwnerCategoriesFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  OwnerCategoriesProvider._internal(
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
    FutureOr<List<CategoryModel>> Function(OwnerCategoriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnerCategoriesProvider._internal(
        (ref) => create(ref as OwnerCategoriesRef),
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
    return _OwnerCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnerCategoriesProvider && other.shopId == shopId;
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
mixin OwnerCategoriesRef on AutoDisposeFutureProviderRef<List<CategoryModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _OwnerCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryModel>>
    with OwnerCategoriesRef {
  _OwnerCategoriesProviderElement(super.provider);

  @override
  String get shopId => (origin as OwnerCategoriesProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
