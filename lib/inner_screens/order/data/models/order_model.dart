import 'package:shop_smart_user/inner_screens/order/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.orderId,
    required super.userId,
    required super.productId,
    required super.productTitle,
    required super.userName,
    required super.price,
    required super.imageUrl,
    required super.quantity,
    required super.orderDate,
  });
}
