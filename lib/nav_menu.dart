import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/features/Home/screens/payments/payments.dart';
import 'package:goodfellow/features/Home/screens/profile/profile.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
// import 'package:group_savings/features/Home/screens/Group-savings/group/group.dart';
// import 'package:group_savings/features/Home/screens/Group-savings/group/manage_group.dart';
// import 'package:group_savings/features/Home/screens/Group-savings/home/home.dart';
// import 'package:group_savings/features/Home/screens/Group-savings/settings/settings.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:lucide_icons/lucide_icons.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = APPHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          backgroundColor: darkMode ? APPColors.black : Colors.white,
          indicatorColor: darkMode
              ? APPColors.white.withValues(alpha: 0.1)
              : APPColors.black.withValues(alpha: 0.1),
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: controller.destinations,
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  void resetIndex() => selectedIndex.value = 0;
  final deviceStorage = GetStorage();

  late List<Widget> screens;
  late List<NavigationDestination> destinations;

  @override
  void onInit() {
    super.onInit();

    // final userType = deviceStorage.read("userType");

    // Initialize screens list
    screens = [
      const HomeScreen(),
      const PaymentsScreen(),
      const ProfileScreen(),
    ];

    // // Initialize destinations list
    destinations = [
      const NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
      const NavigationDestination(
        icon: Icon(Iconsax.wallet),
        label: 'Payments',
      ),
      const NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
    ];

    // if (userType == "chairperson" ||
    //     userType == "secretary" ||
    //     userType == "treasurer") {
    //   destinations.add(
    //     const NavigationDestination(
    //       icon: Icon(LucideIcons.alignCenterVertical),
    //       label: 'Manage',
    //     ),
    //   );
    // }
  }
}
