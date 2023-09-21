import 'package:flutter/material.dart';
import 'package:shop_smart_user/core/resources/constance.dart';
import 'package:shop_smart_user/home/presentation/widgets/category_wigdet.dart';
import 'package:shop_smart_user/home/presentation/widgets/list_arrival_widget.dart';
import 'package:shop_smart_user/home/presentation/widgets/slider_widget.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/widgets/app_name_widget.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/HomeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(AssetsManager.shoppingCart),
        title: const AppNameWidget(
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: const SliderWidget(),
              ),
              const ListArrivalWidget(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  AppConstants.categoriesList.length,
                  (index) => CategoryWidget(
                    name: AppConstants.categoriesList[index].name,
                    image: AppConstants.categoriesList[index].image,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
