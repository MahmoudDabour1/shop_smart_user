import 'package:dartz/dartz.dart';
import 'package:shop_smart_user/core/error/failure.dart';
import 'package:shop_smart_user/products_details/domain/entities/products.dart';

abstract class BaseProductsRepository{
  Future<Either<Failure,List<Products>>> getProducts();
}