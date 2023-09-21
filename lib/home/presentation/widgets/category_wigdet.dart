import 'package:flutter/material.dart';
import 'package:shop_smart_user/search/presentation/screens/search_screen.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.name,
    required this.image,
  });

  final String name, image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SearchScreen.routeName,
          arguments: name,
        );
      },
      child: Column(
        children: [
          Image.asset(
            image,
            height: 50,
            width: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 3.5),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
