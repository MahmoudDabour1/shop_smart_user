import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/cart/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/widgets/quantity_btm_sheet_widget.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';

import '../../../core/widgets/heart_button_widget.dart';
import '../../data/models/cart_model.dart';

class CartDetailsWidget extends StatefulWidget {
  const CartDetailsWidget({super.key});

  @override
  State<CartDetailsWidget> createState() => _CartDetailsWidgetState();
}

class _CartDetailsWidgetState extends State<CartDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final cartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final getCurrentProduct =
        productProvider.findByProductId(cartModelProvider.productId);

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.6,
                                child: Text(
                                  getCurrentProduct.productTitle,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        MyAppErrorMethods
                                            .showErrorOrWarningDialog(
                                                isError: false,
                                                context: context,
                                                title: "Remove item",
                                                fct: () async {
                                                  await cartProvider
                                                      .removeCartItemFromFirebase(
                                                    cartId: cartModelProvider
                                                        .cartId,
                                                    productId: cartModelProvider
                                                        .productId,
                                                    qty: cartModelProvider
                                                        .quantity,
                                                  );

                                                  // cartProvider.removeOneItem(
                                                  //     productId:
                                                  //         getCurrentProduct
                                                  //             .productId);
                                                });
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      )),
                                  HeartButtonWidget(
                                      productId: getCurrentProduct.productId),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "${getCurrentProduct.productPrice}\$",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              const Spacer(),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    context: context,
                                    builder: (context) {
                                      return QuantityBtmSheetWidget(
                                        cartModel: cartModelProvider,
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(IconlyLight.arrowDown2),
                                label:
                                    Text("Qty: ${cartModelProvider.quantity}"),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
