import 'package:shop_smart_user/core/resources/assets_manager.dart';
import 'package:shop_smart_user/home/domain/entities/categoy_model.dart';

class AppConstants {
  static const imageUrl = "https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png";

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  static List<CategoryModel> categoriesList = [
    CategoryModel(
      id: "Phones",
      image: AssetsManager.mobiles,
      name: "Phones",
    ),
    CategoryModel(
      id: "Laptops",
      image: AssetsManager.pc,
      name: "Laptops",
    ),
    CategoryModel(
      id: "Electronics",
      image: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoryModel(
      id: "Watches",
      image: AssetsManager.watch,
      name: "Watches",
    ),
    CategoryModel(
      id: "Clothes",
      image: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoryModel(
      id: "Shoes",
      image: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoryModel(
      id: "Books",
      image: AssetsManager.book,
      name: "Books",
    ),
    CategoryModel(
      id: "Cosmetics",
      image: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];
}
