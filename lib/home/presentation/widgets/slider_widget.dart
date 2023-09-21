import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:shop_smart_user/core/resources/constance.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12),
        topLeft: Radius.circular(12),
      ),
      child: Swiper(
        autoplay: true,
        itemCount: AppConstants.bannersImages.length,
        controller: SwiperController(),
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
            color: Colors.grey,
            activeColor: Colors.blue,
          ),
        ),
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            AppConstants.bannersImages[index],
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }
}
