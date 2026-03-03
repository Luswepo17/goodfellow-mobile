// // import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// // import 'package:package_info_plus/package_info_plus.dart';
// import 'package:goodfellow/common/text/offline_text.dart';
// import 'package:goodfellow/common/text/update_available.dart';
// import 'package:goodfellow/features/Home/screens/home/widgets/home_card_button.dart';
// import 'package:goodfellow/features/Home/screens/home/widgets/greetings_card.dart';
// import 'package:goodfellow/features/Home/screens/home/widgets/loading_card.dart';
// import 'package:goodfellow/features/Home/screens/home/widgets/promo_banners.dart';
// import 'package:goodfellow/features/Home/screens/home/widgets/sticky_header.dart';
// import 'package:goodfellow/features/Home/screens/transaction_history/history.dart';
// import 'package:goodfellow/utils/constants/api_constants.dart';
// import 'package:goodfellow/utils/constants/colors.dart';
// import 'package:goodfellow/utils/constants/sizes.dart';
// import 'package:goodfellow/utils/constants/text_string.dart';
// import 'package:goodfellow/utils/helpers/helper_functions.dart';
// import 'package:goodfellow/utils/http/http_client.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _isLoading = true; // Track loading state
//   bool isRefreshing = false;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _simulateLoading(); // Start loading simulation
//   }

//   Future<void> _simulateLoading() async {
//     await Future.delayed(const Duration(seconds: 2)); // Initial loading time
//     setState(() {
//       _isLoading = false; // Set loading to false after all cards are shown
//     });
//   }

//   // Refresh function that simulates reloading
//   Future<void> _onRefresh() async {
//     setState(() {
//       _isLoading = true;
//       isRefreshing = true;
//     });

//     // Refresh QuickServices data
//     // You might want to create a method to refresh QuickServices specifically

//     await Future.delayed(const Duration(seconds: 2));

//     if (mounted) {
//       setState(() {
//         _isLoading = false;
//         isRefreshing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dark = APPHelperFunctions.isDarkMode(context);
//     return Scaffold(
//       backgroundColor: dark ? APPColors.dark : APPColors.softgrey,
//       body: RefreshIndicator(
//         onRefresh: _onRefresh,
//         child: CustomScrollView(
//           controller: _scrollController,
//           physics: const AlwaysScrollableScrollPhysics(), // This is important
//           slivers: [
//             // Sticky Header
//             const SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   StickyHeader(),
//                   SizedBox(height: APPSizes.spaceBtwItem),
//                 ],
//               ),
//             ),

//             // Main Content
//             SliverPadding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: APPSizes.defaultSpace / 1.5,
//               ),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   const OfflineText(),

//                   const UpdateAvailable(),
//                   const GreetingsCard(),
//                   const SizedBox(height: APPSizes.spaceBtwItem / 2),
//                   const Divider(),
//                   const SizedBox(height: APPSizes.spaceBtwItem / 2),
//                   // QuickServices(isRefreshing: isRefreshing),
//                   const SizedBox(height: APPSizes.spaceBtwSections),

//                   const SizedBox(height: APPSizes.spaceBtwSections),

//                   const PromoBanners(),
//                   const SizedBox(height: APPSizes.spaceBtwSections),
//                   ElevatedButton(
//                     onPressed: () {
//                       checkDeviceInfo();
//                     },
//                     child: const Text("Manual Location Update"),
//                   ),
//                   const SizedBox(height: APPSizes.spaceBtwSections),
//                   //const RecentTransactions(),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void checkDeviceInfo() async {
//     print("📍 Starting checkDeviceInfo...");

//     final deviceStorage = GetStorage("setup");

//     Map<String, String> getFallbackLocation() {
//       final storedLat = deviceStorage.read('last_latitude') ?? "0.0";
//       final storedLng = deviceStorage.read('last_longitude') ?? "0.0";
//       print("⚠️ Using fallback location: $storedLat, $storedLng");
//       return {"latitude": storedLat, "longitude": storedLng};
//     }

//     Future<Map<String, String>> getLocationSafely() async {
//       try {
//         // print("📡 Attempting to get current location...");
//         final position = await Geolocator.getCurrentPosition(
//           // ignore: deprecated_member_use
//           desiredAccuracy: LocationAccuracy.low,
//           // ignore: deprecated_member_use
//           forceAndroidLocationManager: true,
//         );
//         // print(
//         // "✅ Location retrieved: ${position.latitude}, ${position.longitude}");

//         return {
//           "latitude": position.latitude.toString(),
//           "longitude": position.longitude.toString(),
//         };
//       } catch (e) {
//         print("❌ Location error: $e");
//         return getFallbackLocation();
//       }
//     }

//     final locationInfo = await getLocationSafely();

//     print("📦 Preparing location data...");
//     final locationData = {
//       'posdevice_id': deviceStorage.read('posdevice_id') ?? '',
//       'latitude': locationInfo["latitude"]!,
//       'longitude': locationInfo["longitude"]!,
//       'timestamp': DateTime.now().toIso8601String(),
//       'accuracy': "low",
//       'region': '', // Optional: add reverse geocoding if needed
//       'ip_address': '', // Remove if not needed anymore
//       'city': '', // Optional: add reverse geocoding if needed
//     };

//     print("📤 Sending location data to: ${APIConstants.pinglocationendpoint}");
//     print("📝 Payload: $locationData");

//     final res = await APPHttpHelper.postMaster(
//       APIConstants.pinglocationendpoint,
//       '',
//       locationData,
//     );

//     print("✅ Server Response: $res");
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/promo_banners.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/sticky_header.dart';
import 'package:goodfellow/features/Home/screens/pay/pay.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true; // Track loading state
  bool isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic>? activeContract;

  @override
  void initState() {
    super.initState();
    _simulateLoading(); // Start loading simulation
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await getContractForPhone();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 2)); // Initial loading time
    setState(() {
      _isLoading = false; // Set loading to false after all cards are shown
    });
  }

  // Refresh function that simulates reloading
  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
      isRefreshing = true;
    });

    // Refresh QuickServices data
    // You might want to create a method to refresh QuickServices specifically

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        isRefreshing = false;
      });
    }
  }

  //Get Current Contract

  Future<void> getContractForPhone() async {
    try {
      final deviceStorage = GetStorage();
      final phoneId = deviceStorage.read("phone_id") ?? "";
      final token = deviceStorage.read("token") ?? "";

      final res = await APPHttpHelper.get(
        APIConstants.publicUrl,
        "${APIConstants.getContractsendpoint}/$phoneId",
        token,
      );

      if (res["status"] == "success") {
        final List<dynamic> fetchedContracts = res["data"]?["contracts"] ?? [];
        if (fetchedContracts.isNotEmpty) {
          setState(() {
            activeContract =
                fetchedContracts[0]; // Assuming the first one is the target
          });
        }
      } else {
        APPLoaders.errorSnackBar(title: "Error", message: res["message"]);
      }
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: "Connection Error",
        message: e.toString(),
      );
    }
  }

  //Get Installments
  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    // Calculate Progress: (Total Paid / Total Amount)
    double totalAmount =
        double.tryParse(activeContract?['total_amount'] ?? '1') ?? 1.0;
    double amountPaid =
        double.tryParse(activeContract?['amount_paid'] ?? '0') ?? 0.0;
    double progress = amountPaid / totalAmount;
    int progressPercent = (progress * 100).toInt();

    return Scaffold(
      backgroundColor: dark ? APPColors.dark : APPColors.softgrey,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: StickyHeader()),

            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (activeContract == null)
              const SliverFillRemaining(
                child: Center(child: Text("No Active Contracts Found")),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: APPSizes.defaultSpace / 1.5,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const OfflineText(),

                    SizedBox(height: APPSizes.spaceBtwSections),

                    // 1. DEVICE & OWNERSHIP STATUS
                    APPRoundedContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(APPSizes.defaultSpace),
                      backgroundColor: dark
                          ? APPColors.darkerGrey
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activeContract?['phone_name'] ?? "Device Info",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              _buildStatusChip(
                                activeContract?['status'] ?? "Unknown",
                              ),
                            ],
                          ),
                          const SizedBox(height: APPSizes.spaceBtwItem),
                          Text(
                            "Ownership Progress ($progressPercent%)",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: APPColors.grey.withOpacity(0.3),
                            color: dark
                                ? APPColors.secondary
                                : APPColors.primary,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: APPSizes.spaceBtwItem),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Paid: ZMW $amountPaid",
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              Text(
                                "Remaining: ZMW ${activeContract?['contract_remaining_amount']}",
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwItem),

                    // 2. PAYMENT DUE CARD
                    APPRoundedContainer(
                      padding: const EdgeInsets.all(APPSizes.defaultSpace),
                      backgroundColor: APPColors.primary,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.calendarCheck,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: APPSizes.md),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Next Installment",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    "ZMW ${activeContract?['next_payment_balance']}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Due: ${APPHelperFunctions.getFormattedDate(DateTime.parse(activeContract?['next_installment_date']))}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  Get.to(
                                    () => PayNow(
                                      installmentId:
                                          activeContract?['next_installment_id'] ??
                                          "",
                                    ),
                                  ),
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: APPColors.primary,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      25,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: const Text("Pay Now"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),

                    // QUICK ACTIONS
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionBtn(
                            context,
                            "History",
                            LucideIcons.history,
                            () {},
                          ),
                        ),
                        const SizedBox(width: APPSizes.spaceBtwItem),
                        Expanded(
                          child: _buildActionBtn(
                            context,
                            "Details",
                            LucideIcons.fileText,
                            () {},
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: APPSizes.spaceBtwSections),
                    const PromoBanners(),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    bool isActive = status.toLowerCase() == "active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "● ${status.toUpperCase()}",
        style: TextStyle(
          color: isActive ? Colors.green : Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionBtn(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: APPRoundedContainer(
        padding: const EdgeInsets.all(APPSizes.md),
        backgroundColor: APPHelperFunctions.isDarkMode(context)
            ? APPColors.darkerGrey
            : Colors.white,
        child: Column(
          children: [
            Icon(
              icon,
              color: APPHelperFunctions.isDarkMode(context)
                  ? APPColors.secondary
                  : APPColors.primary,
            ),
            const SizedBox(height: APPSizes.xs),
            Text(title, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
