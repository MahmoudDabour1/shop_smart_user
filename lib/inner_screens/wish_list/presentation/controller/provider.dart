import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_smart_user/inner_screens/wish_list/data/models/wish_list_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/widgets/error_methods_widget.dart';

class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishListItems = {};

  Map<String, WishListModel> get getWishListItems {
    return _wishListItems;
  }

  bool isProductInWishList({required String productId}) {
    return _wishListItems.containsKey(productId);
  }

  final userDB = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;

  Future<void> addToWishListFirebase({
    required String productId,
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
    final wishListId = const Uuid().v4();
    try {
      userDB.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishListId': wishListId,
            'productId': productId,
          }
        ])
      });
      // await fetchWishList();
      Fluttertoast.showToast(msg: "Item has been added to wish list");
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchWishList() async {
    User? user = _auth.currentUser;
    if (user == null) {
      _wishListItems.clear();
      return;
    }
    try {
      final userDoc = await userDB.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey("userWish")) {
        return;
      }
      final length = userDoc.get("userWish").length;
      for (int index = 0; index < length; index++) {
        _wishListItems.putIfAbsent(
          userDoc.get('userWish')[index]['productId'],
          () => WishListModel(
            id: userDoc.get('userWish')[index]['wishListId'],
            productId: userDoc.get('userWish')[index]['productId'],
          ),
        );
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearWishListFromFirebase() async {
    User? user = _auth.currentUser;
    try {
      await userDB.doc(user!.uid).update({"userWish": []});
      _wishListItems.clear();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeWishListItemFromFirebase({
    required String wishListId,
    required String productId,
  }) async {
    User? user = _auth.currentUser;
    try {
      await userDB.doc(user!.uid).update({
        "userWish": FieldValue.arrayRemove([
          {
            'wishListId': wishListId,
            'productId': productId,
          }
        ])
      });
      _wishListItems.remove(productId);
      await fetchWishList();
    } catch (error) {
      rethrow;
    }
  }

  void addOrRemoveProductToWishList({required String productId}) {
    if (_wishListItems.containsKey(productId)) {
      _wishListItems.remove(productId);
    } else {
      _wishListItems.putIfAbsent(
        productId,
        () => WishListModel(
          id: const Uuid().v4(),
          productId: productId,
        ),
      );
    }
    notifyListeners();
  }

  void clearLocalWishList() {
    _wishListItems.clear();
    notifyListeners();
  }
}
