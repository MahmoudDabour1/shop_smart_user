// ignore_for_file: must_be_immutable

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/resources/assets_manager.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/presentation/controller/provider.dart';
import 'package:shop_smart_user/products_details/presentation/screens/products_details_screen.dart';

import '../../../../core/widgets/empty_bag_widget.dart';
import '../../../../core/widgets/error_methods_widget.dart';
import '../../../../products_details/presentation/widgets/products_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  ViewedRecentlyScreen({super.key});

  static const routeName = '/ViewedRecentlyScreen';

  @override
  Widget build(BuildContext context) {
    final viewedRecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);
    return viewedRecentlyProvider.getViewedRecentlyItems.isEmpty
        ? Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: EmptyBagWidget(
                  imagePath: AssetsManager.bagWish,
                  text: "Your viewed recently is empty",
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
                  "Viewed Recently (${viewedRecentlyProvider.getViewedRecentlyItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              itemCount: viewedRecentlyProvider.getViewedRecentlyItems.length,
              crossAxisCount: 2,
              builder: (context, index) {
                return ProductsWidget(
                    productId: viewedRecentlyProvider
                        .getViewedRecentlyItems.values
                        .toList()[index]
                        .productId);
              },
            ),
          );
  }
}
