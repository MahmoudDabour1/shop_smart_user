import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/presentation/controller/provider.dart';

import '../../cart/presentation/controller/provider.dart';
import '../../products_details/data/models/products_model.dart';
import '../../products_details/presentation/controller/provider.dart';
import '../../products_details/presentation/screens/products_details_screen.dart';
import 'heart_button_widget.dart';

class LatestArrivalWidget extends StatefulWidget {
  const LatestArrivalWidget({super.key, required this.productId});

  final String productId;

  @override
  State<LatestArrivalWidget> createState() => _LatestArrivalWidgetState();
}

class _LatestArrivalWidgetState extends State<LatestArrivalWidget> {
  @override
  Widget build(BuildContext context) {
    final productModelProvider = Provider.of<ProductModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProductId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedRecentlyProvider = Provider.of<ViewedRecentlyProvider>(context);

    Size size = MediaQuery.of(context).size;
    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : GestureDetector(
            onTap: () async {
              viewedRecentlyProvider.addProductHistory(
                  productId: productModelProvider.productId);
              await Navigator.pushNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: getCurrentProduct.productId,
              );
            },
            child: SizedBox(
              width: size.width * 0.50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: FancyShimmerImage(
                        imageUrl: productModelProvider.productImage,
                        width: size.width * 0.28,
                        height: size.width * 0.28,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModelProvider.productTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () async{
                                    if (cartProvider.isProductInCart(
                                        productId:
                                            getCurrentProduct.productId)) {
                                      return;
                                    }
                                    try {
                                      await cartProvider.addToCartFirebase(
                                        productId: getCurrentProduct.productId,
                                        qty: 1,
                                        context: context,
                                      );
                                    } catch (error) {
                                      MyAppErrorMethods.showErrorOrWarningDialog(
                                        context: context,
                                        title: error.toString(),
                                        fct: () {},
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    cartProvider.isProductInCart(
                                            productId:
                                                getCurrentProduct.productId)
                                        ? Icons.check
                                        : Icons.add_shopping_cart_outlined,
                                  ),
                                ),
                                HeartButtonWidget(
                                    productId: productModelProvider.productId),
                              ],
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "${productModelProvider.productPrice}\$",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
