import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNameWidget extends StatelessWidget {
  const AppNameWidget({super.key, this.fontSize = 30});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 10),
      baseColor: Colors.purple,
      highlightColor: Colors.red,
      child: Text(
        "Shop Smart",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
