import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:goodfellow/features/authentication/controllers/updates/update_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start download when screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final updateController = Get.find<UpdateController>();
      if (updateController.downloadState.value != DownloadState.downloading &&
          updateController.downloadState.value != DownloadState.completed) {
        updateController.startDownload();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateController = Get.put(UpdateController());
    final dark = APPHelperFunctions.isDarkMode(context);
    final isForced = updateController.isForcedUpdate.value;

    return PopScope(
      canPop: !isForced,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  height: 150,
                  image: AssetImage(
                    dark ? APPImages.lightAppLogo : APPImages.darkAppLogo,
                  ),
                ),
                const SizedBox(height: APPSizes.spaceBtwSections),
                Text(
                  isForced ? "Update Required" : "Update Available",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: APPSizes.spaceBtwItem),
                Obx(() {
                  final state = updateController.downloadState.value;
                  final progress = updateController.downloadProgress.value;
                  final error = updateController.errorMessage.value;

                  if (state == DownloadState.error) {
                    return Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: APPSizes.spaceBtwItem),
                        Text(
                          "Update Failed",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: APPSizes.spaceBtwItem / 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: APPSizes.defaultSpace,
                          ),
                          child: Text(
                            error.isNotEmpty
                                ? error
                                : "An error occurred during download",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: APPSizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              updateController.startDownload();
                            },
                            child: const Text("Retry Download"),
                          ),
                        ),
                      ],
                    );
                  }

                  if (state == DownloadState.completed ||
                      state == DownloadState.installing) {
                    return Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 60),
                        const SizedBox(height: APPSizes.spaceBtwItem),
                        Text(
                          state == DownloadState.installing
                              ? "Installing Update..."
                              : "Download Complete!",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: APPSizes.spaceBtwItem),
                        Text(
                          state == DownloadState.installing
                              ? "Please follow the installation prompts"
                              : "The installer will open shortly",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Text(
                        "Downloading update...",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: APPSizes.spaceBtwSections),
                      // Progress bar
                      Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: APPColors.grey.withOpacity(0.2),
                        ),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              widthFactor: progress / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: APPColors.primary,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "${progress.toStringAsFixed(0)}%",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .apply(
                                      color: progress > 50
                                          ? APPColors.white
                                          : APPColors.dark,
                                      fontWeightDelta: 2,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: APPSizes.spaceBtwItem),
                      // Linear progress indicator
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: APPColors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          APPColors.primary,
                        ),
                        minHeight: 4,
                      ),
                      const SizedBox(height: APPSizes.spaceBtwSections),
                      LottieBuilder.asset(
                        "assets/images/animations/loading.json",
                        width: 100,
                        height: 100,
                      ),
                    ],
                  );
                }),
                if (!isForced &&
                    updateController.downloadState.value !=
                        DownloadState.downloading)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: APPSizes.spaceBtwSections,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
