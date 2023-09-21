import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Products extends Equatable {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productQuantity,
      productImage;
  Timestamp? createdAt;

   Products({
    required this.productId,
    required this.productTitle,
    required this.productPrice,
    required this.productCategory,
    required this.productDescription,
    required this.productQuantity,
    required this.productImage,
    this.createdAt,
  });

  @override
  List<Object> get props => [
        productId,
        productTitle,
        productPrice,
        productCategory,
        productQuantity,
        productDescription,
        productImage,
      ];
}
