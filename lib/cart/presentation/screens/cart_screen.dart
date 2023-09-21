import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/auth/user/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/widgets/bottom_checkout_widget.dart';
import 'package:shop_smart_user/cart/presentation/widgets/cart_details_widget.dart';
import 'package:shop_smart_user/core/resources/assets_manager.dart';
import 'package:shop_smart_user/core/widgets/empty_bag_widget.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import 'package:shop_smart_user/core/widgets/loading_manager.dart';
import 'package:shop_smart_user/search/presentation/screens/search_screen.dart';
import 'package:uuid/uuid.dart';

import '../../../products_details/presentation/controller/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final bool isEmpty = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: EmptyBagWidget(
                  imagePath: AssetsManager.shoppingBasket,
                  text: "Your Card is empty",
                  subText:
                      "Look like you didn't add anything yet to your cart \n go ahead and start shopping now",
                  buttonText: "Shop Now",
                  function: () {
                    Navigator.pushNamed(
                      context,
                      SearchScreen.routeName,
                    );
                  },
                ),
              ),
            ),
          )
        : Scaffold(
            bottomSheet: CartBottomCheckOutWidget(function: () async {
              await placeOrder(
                cartProvider: cartProvider,
                productProvider: productProvider,
                userProvider: userProvider,
              );
            }),
            appBar: AppBar(
              title: Text("Cart (${cartProvider.getCartItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppErrorMethods.showErrorOrWarningDialog(
                        isError: false,
                        context: context,
                        title: "Remove Cart Items",
                        fct: () async {
                          await cartProvider.clearCartFromFirebase();
                          cartProvider.clearLocalCart();
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: LoadingManager(
              isLoading: isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartProvider.getCartItems.length,
                        itemBuilder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: cartProvider.getCartItems.values
                                .toList()
                                .reversed
                                .toList()[index],
                            child: const CartDetailsWidget(),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight + 20,
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> placeOrder({
    required CartProvider cartProvider,
    required ProductProvider productProvider,
    required UserProvider userProvider,
  }) async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    try {
      setState(() {
        isLoading = true;
      });
      cartProvider.getCartItems.forEach((key, value) async {
        final getCurrProduct =
            productProvider.findByProductId(value.productId);
        final orderId = const Uuid().v4();
        await FirebaseFirestore.instance.collection("ordersAdvanced").doc(orderId).set({
          'orderId': orderId,
          'userId': uid,
          'productId': value.productId,
          "productTitle": getCurrProduct!.productTitle,
          'price': double.parse(getCurrProduct.productPrice) * value.quantity,
          'totalPrice': cartProvider.getTotal(productProvider: productProvider),
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.productImage,
          'userName': userProvider.getUserModel!.userName,
          'orderDate': Timestamp.now(),
        });
      });
      await cartProvider.clearCartFromFirebase();
      cartProvider.clearLocalCart();
    } catch (error) {
      MyAppErrorMethods.showErrorOrWarningDialog(
        context: context,
        title: error.toString(),
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
