import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_smart_user/cart/data/models/cart_model.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import 'package:shop_smart_user/products_details/data/models/products_model.dart';
import 'package:uuid/uuid.dart';

import '../../../products_details/presentation/controller/provider.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addToCartFirebase({
    required String productId,
    required int qty,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppErrorMethods.showErrorOrWarningDialog(
        context: context,
        title: "No user found",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final cartId = const Uuid().v4();
    try {
      userDB.doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      await fetchCart();
      Fluttertoast.showToast(msg: "Item has been added to cart");
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchCart() async {
    User? user = _auth.currentUser;
    if (user == null) {
      _cartItems.clear();
      return;
    }
    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userCart")) {
        return;
      }
      final length = userDoc.get("userCart").length;
      for (int index = 0; index < length; index++) {
        _cartItems.putIfAbsent(
          userDoc.get('userCart')[index]['productId'],
          () => CartModel(
            cartId: userDoc.get('userCart')[index]['cartId'],
            productId: userDoc.get('userCart')[index]['productId'],
            quantity: userDoc.get('userCart')[index]['quantity'],
          ),
        );
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearCartFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await userDB.doc(user!.uid).update({"userCart": []});
      _cartItems.clear();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeCartItemFromFirebase({
    required String cartId,
    required String productId,
    required int qty,
  }) async {
    User? user = _auth.currentUser;
    try {
      await userDB.doc(user!.uid).update({
        "userCart": FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': qty,
          }
        ])
      });
      _cartItems.remove(productId);
    } catch (error) {
      rethrow;
    }
  }

  bool isProductInCart({required String productId}) {
    return _cartItems.containsKey(productId);
  }

  void addProductToCart({required String productId}) {
    _cartItems.putIfAbsent(
      productId,
      () => CartModel(
        cartId: const Uuid().v4(),
        productId: productId,
        quantity: 1,
      ),
    );
    notifyListeners();
  }

  void updateQuantity({required String productId, required int quantity}) {
    _cartItems.update(
      productId,
      (item) => CartModel(
        cartId: item.cartId,
        productId: productId,
        quantity: quantity,
      ),
    );
    notifyListeners();
  }

  double getTotal({required ProductProvider productProvider}) {
    double total = 0.0;
    _cartItems.forEach((key, value) {
      final ProductModel? getCurrentProduct =
          productProvider.findByProductId(value.productId);
      if (getCurrentProduct == null) {
        total += 0;
      } else {
        total += double.parse(getCurrentProduct.productPrice) * value.quantity;
      }
    });
    return total;
  }

  void removeOneItem({required String productId}) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearLocalCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int getQuantity() {
    int quantity = 0;
    _cartItems.forEach((key, value) {
      quantity += value.quantity;
    });
    return quantity;
  }
}
