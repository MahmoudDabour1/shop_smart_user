import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/products_details/presentation/controller/provider.dart';

import '../../../core/widgets/latest_arrival_widget.dart';

class ListArrivalWidget extends StatelessWidget {
  const ListArrivalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    // final productId = ModalRoute.of(context)!.settings.arguments as String;
    // final  getCurrentProduct = productProvider.findByProductId(productId);

    Size size = MediaQuery.of(context).size;
    return Visibility(
      visible: productProvider.getProducts.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Latest arrival",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            child: ListView.builder(
                itemCount: productProvider.getProducts.length < 10
                    ? productProvider.getProducts.length
                    : 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                      value: productProvider.getProducts[index],
                      child: LatestArrivalWidget(
                        productId: productProvider.getProducts[index].productId,
                      ));
                }),
          ),
        ],
      ),
    );
  }
}
