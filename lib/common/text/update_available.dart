import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:goodfellow/common/dialogs/custom_dialog.dart';
import 'package:goodfellow/features/authentication/controllers/updates/update_controller.dart';
import 'package:goodfellow/features/authentication/screens/updates/update_screen.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class UpdateAvailable extends StatefulWidget {
  const UpdateAvailable({super.key});

  @override
  State<UpdateAvailable> createState() => _UpdateAvailableState();
}

class _UpdateAvailableState extends State<UpdateAvailable> {
  @override
  Widget build(BuildContext context) {
    final UpdateController controller = Get.put(UpdateController());

    final deviceStorage = GetStorage();
    final releaseNotes = deviceStorage.read("releaseNotes") ?? "";
    return Obx(() {
      return controller.isUpdateAvailable.value
          ? GestureDetector(
              onTap: () {
                showCustomDialog(
                  showClose: true,
                  icon: LucideIcons.badgeAlert,
                  title: "Update Available",
                  content: Column(
                    children: [
                      const Text("A new update is available."),
                      const SizedBox(height: APPSizes.spaceBtwItem),
                      Text(
                        "**Release Notes**",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                      ),
                      Text(
                        releaseNotes,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: APPSizes.spaceBtwItem),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {
                            Get.offAll(() => const UpdateScreen()),
                            controller.downloadAndInstallApk(),
                          },
                          child: const Text("Update now"),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        "Update Available",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
