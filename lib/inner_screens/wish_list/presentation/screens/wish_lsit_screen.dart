// ignore_for_file: must_be_immutable

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/resources/assets_manager.dart';
import 'package:shop_smart_user/inner_screens/wish_list/presentation/controller/provider.dart';
import 'package:shop_smart_user/products_details/presentation/screens/products_details_screen.dart';

import '../../../../core/widgets/empty_bag_widget.dart';
import '../../../../core/widgets/error_methods_widget.dart';
import '../../../../products_details/presentation/widgets/products_widget.dart';

class WishListScreen extends StatelessWidget {
  WishListScreen({super.key});

  static const routeName = '/WishListScreen';

  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListProvider>(context);
    return wishListProvider.getWishListItems.isEmpty
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: EmptyBagWidget(
                  imagePath: AssetsManager.shoppingBasket,
                  text: "Your wishList is empty",
                  subText:
                      "Look like you didn't add anything yet to your cart \n go ahead and start shopping now",
                  buttonText: "Shop Now",
                  function: () {},
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                  "Wish List (${wishListProvider.getWishListItems.length})"),
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
                        fct: () {
                          wishListProvider.clearWishListFromFirebase();
                          wishListProvider.clearLocalWishList();
                        });
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              itemCount: wishListProvider.getWishListItems.length,
              crossAxisCount: 2,
              builder: (context, index) {
                return ProductsWidget(
                    productId: wishListProvider.getWishListItems.values
                        .toList()[index]
                        .productId);
              },
            ),
          );
  }
}
