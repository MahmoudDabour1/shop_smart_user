import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';

import '../controller/provider.dart';

class CartBottomCheckOutWidget extends StatelessWidget {
  const CartBottomCheckOutWidget({super.key, required this.function});

  final Function function;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return SizedBox(
      height: kBottomNavigationBarHeight + 25,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(
            top: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        "Total(${cartProvider.getCartItems.length} Products/${cartProvider.getQuantity()} Items)",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "${cartProvider.getTotal(productProvider: productProvider)}\$",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await function();
                  },
                  child: const Text(
                    "Checkout",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
