import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String cartId;
  final String productId;
  final int quantity;

  const Cart({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [
        cartId,
        productId,
        quantity,
      ];
}
