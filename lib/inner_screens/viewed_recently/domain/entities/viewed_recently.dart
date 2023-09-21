import 'package:equatable/equatable.dart';

class ViewedRecently extends Equatable {
  final String id;
  final String productId;

  const ViewedRecently({
    required this.id,
    required this.productId,
  });

  @override
  List<Object> get props => [
        id,
        productId,
      ];
}
