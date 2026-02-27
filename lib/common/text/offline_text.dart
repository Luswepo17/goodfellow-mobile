import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';

class OfflineText extends StatelessWidget {
  const OfflineText({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final connectivityStatus = NetworkManager.instance.connectionStatus;
      if (connectivityStatus == ConnectivityResult.none) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Row(
                  children: [
                    Text(
                      'Offline',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.apply(color: Colors.red),
                    ),
                    const SizedBox(width: APPSizes.spaceBtwItem / 2),
                    // const APPRoundedImage(
                    //     backgroundColor: Colors.transparent,
                    //     height: 16,
                    //     width: 16,
                    //     imageUrl: APPImages.errorStatic),
                  ],
                ),
              ],
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
          ],
        );
      } else {
        return const SizedBox(); // Placeholder when online
      }
    });
  }
}
