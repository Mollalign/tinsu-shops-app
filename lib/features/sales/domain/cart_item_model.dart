import 'package:freezed_annotation/freezed_annotation.dart';
import '../../products/domain/product_model.dart';

part 'cart_item_model.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required ProductModel product,
    required int quantity,
  }) = _CartItem;
}

extension CartItemX on CartItem {
  double get subtotal => product.price * quantity;
}

@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
  }) = _CartState;
}

extension CartStateX on CartState {
  /// Total number of individual units across all items
  int get totalItems => items.fold(0, (s, i) => s + i.quantity);

  /// Number of distinct product lines
  int get lineCount => items.length;

  /// Estimated total for display — backend is source of truth for final total
  double get estimatedTotal =>
      items.fold(0.0, (s, i) => s + i.subtotal);

  bool get isEmpty => items.isEmpty;

  int indexOf(String productId) =>
      items.indexWhere((i) => i.product.id == productId);

  /// Returns quantity for a specific product (0 if not in cart)
  int quantityFor(String productId) {
    final idx = indexOf(productId);
    return idx >= 0 ? items[idx].quantity : 0;
  }
}
