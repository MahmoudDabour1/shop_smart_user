import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/cart/presentation/controller/provider.dart';
import 'package:shop_smart_user/cart/presentation/screens/cart_screen.dart';
import 'package:shop_smart_user/products_details/presentation/widgets/details_widget.dart';

import '../../../core/widgets/app_name_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/ProductDetailsScreen';

  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppNameWidget(
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          },
        ),
        actions: [
          Badge(
            label: Text(cartProvider.getCartItems.length.toString()),
            backgroundColor: Colors.red,
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.blue[400],
              borderRadius: BorderRadius.circular(15),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      CartScreen.routeName,
                    );
                  },
                  icon: const Icon(IconlyLight.bag2)),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            DetailsWidget(),
            // DescriptionWidget(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
