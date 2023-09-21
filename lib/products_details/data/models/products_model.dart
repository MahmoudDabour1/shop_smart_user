// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_smart_user/products_details/domain/entities/products.dart';

class ProductModel extends Products with ChangeNotifier {
  ProductModel({
    required super.productId,
    required super.productTitle,
    required super.productPrice,
    required super.productCategory,
    required super.productDescription,
    required super.productQuantity,
    required super.productImage,
    super.createdAt,
  });

  factory ProductModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      productId: data['productId'], //doc.get("productId"),
      productTitle: data['productTitle'],
      productPrice: data['productPrice'],
      productCategory: data['productCategory'],
      productDescription: data['productDescription'],
      productImage: data['productImage'],
      productQuantity: data['productQuantity'],
      createdAt: data['createdAt'],
    );
  }
}
