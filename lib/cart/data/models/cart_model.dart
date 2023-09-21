// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:shop_smart_user/cart/domain/entities/cart.dart';

class CartModel extends Cart with ChangeNotifier {
   CartModel({
    required super.cartId,
    required super.productId,
    required super.quantity,
  });
}
