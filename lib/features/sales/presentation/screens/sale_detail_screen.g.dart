// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$saleDetailHash() => r'190851d2915ccc138971dd5034557695cf2ba8f7';

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

/// See also [saleDetail].
@ProviderFor(saleDetail)
const saleDetailProvider = SaleDetailFamily();

/// See also [saleDetail].
class SaleDetailFamily extends Family<AsyncValue<SaleModel>> {
  /// See also [saleDetail].
  const SaleDetailFamily();

  /// See also [saleDetail].
  SaleDetailProvider call(String shopId, String saleId) {
    return SaleDetailProvider(shopId, saleId);
  }

  @override
  SaleDetailProvider getProviderOverride(
    covariant SaleDetailProvider provider,
  ) {
    return call(provider.shopId, provider.saleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saleDetailProvider';
}

/// See also [saleDetail].
class SaleDetailProvider extends AutoDisposeFutureProvider<SaleModel> {
  /// See also [saleDetail].
  SaleDetailProvider(String shopId, String saleId)
    : this._internal(
        (ref) => saleDetail(ref as SaleDetailRef, shopId, saleId),
        from: saleDetailProvider,
        name: r'saleDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$saleDetailHash,
        dependencies: SaleDetailFamily._dependencies,
        allTransitiveDependencies: SaleDetailFamily._allTransitiveDependencies,
        shopId: shopId,
        saleId: saleId,
      );

  SaleDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.saleId,
  }) : super.internal();

  final String shopId;
  final String saleId;

  @override
  Override overrideWith(
    FutureOr<SaleModel> Function(SaleDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SaleDetailProvider._internal(
        (ref) => create(ref as SaleDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        saleId: saleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SaleModel> createElement() {
    return _SaleDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleDetailProvider &&
        other.shopId == shopId &&
        other.saleId == saleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, saleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaleDetailRef on AutoDisposeFutureProviderRef<SaleModel> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `saleId` of this provider.
  String get saleId;
}

class _SaleDetailProviderElement
    extends AutoDisposeFutureProviderElement<SaleModel>
    with SaleDetailRef {
  _SaleDetailProviderElement(super.provider);

  @override
  String get shopId => (origin as SaleDetailProvider).shopId;
  @override
  String get saleId => (origin as SaleDetailProvider).saleId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
