import 'package:flutter/material.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: APPHelperFunctions.screenHeight() / 4.5,
        width: APPHelperFunctions.screenWidth() / 2.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey,
        ),
      ),
    );
  }
}
