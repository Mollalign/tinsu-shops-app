import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../products/domain/product_model.dart';
import '../domain/cart_item_model.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  // One idempotency key per checkout session — never regenerated on retry
  String? _idempotencyKey;

  @override
  CartState build() => const CartState();

  String get idempotencyKey {
    _idempotencyKey ??= const Uuid().v4();
    return _idempotencyKey!;
  }

  /// Tap product → add 1 (or increment if already in cart).
  /// This is the core sales interaction.
  void addProduct(ProductModel product) {
    if (!product.isActive || product.isOutOfStock) return;

    final idx = state.indexOf(product.id);
    if (idx >= 0) {
      final existing = state.items[idx];
      final newQty = existing.quantity + 1;
      if (newQty > product.stockQuantity) return; // cap at stock
      final updated = List<CartItem>.from(state.items);
      updated[idx] = existing.copyWith(quantity: newQty);
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
    }
  }

  void increment(String productId) {
    final idx = state.indexOf(productId);
    if (idx < 0) return;
    final item = state.items[idx];
    if (item.quantity >= item.product.stockQuantity) return;
    final updated = List<CartItem>.from(state.items);
    updated[idx] = item.copyWith(quantity: item.quantity + 1);
    state = state.copyWith(items: updated);
  }

  void decrement(String productId) {
    final idx = state.indexOf(productId);
    if (idx < 0) return;
    final item = state.items[idx];
    if (item.quantity <= 1) {
      remove(productId);
      return;
    }
    final updated = List<CartItem>.from(state.items);
    updated[idx] = item.copyWith(quantity: item.quantity - 1);
    state = state.copyWith(items: updated);
  }

  void remove(String productId) {
    state = state.copyWith(
      items: state.items.where((i) => i.product.id != productId).toList(),
    );
  }

  void clear() {
    state = const CartState();
    _idempotencyKey = null; // new checkout session gets a new key
  }
}
