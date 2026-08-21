// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workerDetailHash() => r'b85c32627bb72603cf4e6431b0f11933a58d9e24';

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

/// See also [workerDetail].
@ProviderFor(workerDetail)
const workerDetailProvider = WorkerDetailFamily();

/// See also [workerDetail].
class WorkerDetailFamily extends Family<AsyncValue<WorkerModel>> {
  /// See also [workerDetail].
  const WorkerDetailFamily();

  /// See also [workerDetail].
  WorkerDetailProvider call(String shopId, String workerId) {
    return WorkerDetailProvider(shopId, workerId);
  }

  @override
  WorkerDetailProvider getProviderOverride(
    covariant WorkerDetailProvider provider,
  ) {
    return call(provider.shopId, provider.workerId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workerDetailProvider';
}

/// See also [workerDetail].
class WorkerDetailProvider extends AutoDisposeFutureProvider<WorkerModel> {
  /// See also [workerDetail].
  WorkerDetailProvider(String shopId, String workerId)
    : this._internal(
        (ref) => workerDetail(ref as WorkerDetailRef, shopId, workerId),
        from: workerDetailProvider,
        name: r'workerDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workerDetailHash,
        dependencies: WorkerDetailFamily._dependencies,
        allTransitiveDependencies:
            WorkerDetailFamily._allTransitiveDependencies,
        shopId: shopId,
        workerId: workerId,
      );

  WorkerDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shopId,
    required this.workerId,
  }) : super.internal();

  final String shopId;
  final String workerId;

  @override
  Override overrideWith(
    FutureOr<WorkerModel> Function(WorkerDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkerDetailProvider._internal(
        (ref) => create(ref as WorkerDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shopId: shopId,
        workerId: workerId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WorkerModel> createElement() {
    return _WorkerDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkerDetailProvider &&
        other.shopId == shopId &&
        other.workerId == workerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shopId.hashCode);
    hash = _SystemHash.combine(hash, workerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkerDetailRef on AutoDisposeFutureProviderRef<WorkerModel> {
  /// The parameter `shopId` of this provider.
  String get shopId;

  /// The parameter `workerId` of this provider.
  String get workerId;
}

class _WorkerDetailProviderElement
    extends AutoDisposeFutureProviderElement<WorkerModel>
    with WorkerDetailRef {
  _WorkerDetailProviderElement(super.provider);

  @override
  String get shopId => (origin as WorkerDetailProvider).shopId;
  @override
  String get workerId => (origin as WorkerDetailProvider).workerId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
