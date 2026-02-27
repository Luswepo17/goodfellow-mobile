import 'package:flutter/material.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:shimmer/shimmer.dart';

class LoadingDetailsCard extends StatelessWidget {
  const LoadingDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: APPSizes.defaultSpace),
      child: Shimmer.fromColors(
        baseColor: dark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: dark ? Colors.grey[600]! : Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 20, width: double.infinity, color: Colors.grey),
            const SizedBox(height: 10),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.6,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Container(height: 15, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 15, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 40, width: double.infinity, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
