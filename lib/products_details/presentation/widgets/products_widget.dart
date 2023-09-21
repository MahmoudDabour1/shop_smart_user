import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/widgets/heart_button_widget.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/presentation/controller/provider.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';
import 'package:shop_smart_user/products_details/presentation/screens/products_details_screen.dart';

import '../../../cart/presentation/controller/provider.dart';
import '../../../core/widgets/error_methods_widget.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key, required this.productId});

  final String productId;

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
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
                  productId: getCurrentProduct.productId);
              await Navigator.pushNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: getCurrentProduct.productId,
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.productImage,
                    width: double.infinity,
                    height: size.height * 0.22,
                    boxFit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text(
                        getCurrentProduct.productTitle,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: HeartButtonWidget(
                        productId: getCurrentProduct.productId,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Text(
                          "${getCurrentProduct.productPrice}\$",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.blue,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () async {
                              if (cartProvider.isProductInCart(
                                  productId: getCurrentProduct.productId)) {
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                cartProvider.isProductInCart(
                                        productId: getCurrentProduct.productId)
                                    ? Icons.check
                                    : Icons.add_shopping_cart_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }
}
