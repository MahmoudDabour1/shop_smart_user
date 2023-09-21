import 'package:flutter/cupertino.dart';
import 'package:shop_smart_user/inner_screens/viewed_recently/data/models/viewed_recently_model.dart';
import 'package:uuid/uuid.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedRecentlyModel> _viewedRecentlyItems = {};

  Map<String, ViewedRecentlyModel> get getViewedRecentlyItems {
    return _viewedRecentlyItems;
  }


  void addProductHistory({required String productId}) {
    _viewedRecentlyItems.putIfAbsent(
      productId,
      () => ViewedRecentlyModel(
        id: const Uuid().v4(),
        productId: productId,
      ),
    );
  }
}
