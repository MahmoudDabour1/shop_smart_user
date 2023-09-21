import 'package:equatable/equatable.dart';

class WishList extends Equatable {
  final String id, productId;

  const WishList({
    required this.id,
    required this.productId,
  });

  @override
  List<Object> get props => [
        id,
        productId,
      ];
}
