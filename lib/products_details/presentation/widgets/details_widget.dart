import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/core/widgets/error_methods_widget.dart';
import '../../../cart/presentation/controller/provider.dart';
import '../../../core/widgets/heart_button_widget.dart';
import '../controller/provider.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findByProductId(productId);
    final cartProvider = Provider.of<CartProvider>(context);

    return getCurrentProduct == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(
                  getCurrentProduct.productImage,
                  width: double.infinity,
                  height: size.height * 0.38,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: Text(
                        getCurrentProduct.productTitle,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        "${getCurrentProduct.productPrice}\$",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeartButtonWidget(
                        color: Colors.blue.shade400,
                        productId: getCurrentProduct.productId,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: kBottomNavigationBarHeight - 10,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (cartProvider.isProductInCart(
                                  productId: getCurrentProduct.productId)) {
                                return;
                              } else {
                                // cartProvider.addProductToCart(
                                //   productId: getCurrentProduct.productId,
                                // );
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
                              }
                            },
                            icon: Icon(
                              cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? Icons.check
                                  : Icons.add_shopping_cart_outlined,
                            ),
                            label: Text(
                              cartProvider.isProductInCart(
                                      productId: getCurrentProduct.productId)
                                  ? "In Cart"
                                  : "Add To Card",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "About this item",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Text(
                        "In ${getCurrentProduct.productCategory}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  getCurrentProduct.productDescription,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
  }
}
