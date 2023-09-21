import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_smart_user/inner_screens/order/data/models/order_model.dart';
import 'package:shop_smart_user/inner_screens/order/presentation/controller/provider.dart';
import 'package:shop_smart_user/inner_screens/order/presentation/widgets/order_widget.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/widgets/empty_bag_widget.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          "Placed orders",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: orderProvider.fetchOrder(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText(
                "An error has been occurred ${snapshot.error}",
              ),
            );
          } else if (!snapshot.hasData || orderProvider.getOrders.isEmpty) {
            return EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              text: "No Items",
              subText: "No orders has been placed yet",
              buttonText: "Shop Now",
              function: () {},
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrderWidget(orderModel: orderProvider.getOrders[index]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          );
        }),
      ),
    );
  }
}

// isEmptyOrders
// ? EmptyBagWidget(
// imagePath: AssetsManager.orderBag,
// text: "No Items",
// subText: "No orders has been placed yet",
// buttonText: "Shop Now",
// function: () {})
//     : ListView.separated(
// itemCount: 15,
// itemBuilder: (BuildContext context, int index) {
// return const Padding(
// padding: EdgeInsets.symmetric(horizontal: 2, vertical: 6),
// child: OrderWidget(),
// );
// },
// separatorBuilder: (BuildContext context, int index) {
// return const Divider();
// },
// ),
