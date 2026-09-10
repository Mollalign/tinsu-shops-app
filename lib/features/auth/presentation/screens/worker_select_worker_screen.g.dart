// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_select_worker_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicShopWorkersHash() => r'1ccc9df0ddccd0cdd6dab79e0dbbf8d6f0e9b343';

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

/// Fetches active workers via the public (no-auth) endpoint.
///
/// Copied from [publicShopWorkers].
@ProviderFor(publicShopWorkers)
const publicShopWorkersProvider = PublicShopWorkersFamily();

/// Fetches active workers via the public (no-auth) endpoint.
///
/// Copied from [publicShopWorkers].
class PublicShopWorkersFamily extends Family<AsyncValue<List<WorkerModel>>> {
  /// Fetches active workers via the public (no-auth) endpoint.
  ///
  /// Copied from [publicShopWorkers].
  const PublicShopWorkersFamily();

  /// Fetches active workers via the public (no-auth) endpoint.
  ///
  /// Copied from [publicShopWorkers].
  PublicShopWorkersProvider call(String shopId) {
    return PublicShopWorkersProvider(shopId);
  }

  @override
  PublicShopWorkersProvider getProviderOverride(
    covariant PublicShopWorkersProvider provider,
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
  String? get name => r'publicShopWorkersProvider';
}

/// Fetches active workers via the public (no-auth) endpoint.
///
/// Copied from [publicShopWorkers].
class PublicShopWorkersProvider
    extends AutoDisposeFutureProvider<List<WorkerModel>> {
  /// Fetches active workers via the public (no-auth) endpoint.
  ///
  /// Copied from [publicShopWorkers].
  PublicShopWorkersProvider(String shopId)
    : this._internal(
        (ref) => publicShopWorkers(ref as PublicShopWorkersRef, shopId),
        from: publicShopWorkersProvider,
        name: r'publicShopWorkersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$publicShopWorkersHash,
        dependencies: PublicShopWorkersFamily._dependencies,
        allTransitiveDependencies:
            PublicShopWorkersFamily._allTransitiveDependencies,
        shopId: shopId,
      );

  PublicShopWorkersProvider._internal(
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
    FutureOr<List<WorkerModel>> Function(PublicShopWorkersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PublicShopWorkersProvider._internal(
        (ref) => create(ref as PublicShopWorkersRef),
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
    return _PublicShopWorkersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicShopWorkersProvider && other.shopId == shopId;
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
mixin PublicShopWorkersRef on AutoDisposeFutureProviderRef<List<WorkerModel>> {
  /// The parameter `shopId` of this provider.
  String get shopId;
}

class _PublicShopWorkersProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkerModel>>
    with PublicShopWorkersRef {
  _PublicShopWorkersProviderElement(super.provider);

  @override
  String get shopId => (origin as PublicShopWorkersProvider).shopId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
