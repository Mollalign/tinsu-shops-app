// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_select_shop_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$publicShopsHash() => r'ddc02fb72ec74eccc7a41e0e06f67961853a9606';

/// Fetches shops via the public (no-auth) endpoint.
/// Workers haven't logged in yet, so we must NOT use the auth-injected Dio.
///
/// Copied from [publicShops].
@ProviderFor(publicShops)
final publicShopsProvider = AutoDisposeFutureProvider<List<ShopModel>>.internal(
  publicShops,
  name: r'publicShopsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$publicShopsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PublicShopsRef = AutoDisposeFutureProviderRef<List<ShopModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
