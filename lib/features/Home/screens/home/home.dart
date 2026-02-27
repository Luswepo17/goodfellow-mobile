// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/common/text/update_available.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/home_card_button.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/greetings_card.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/loading_card.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/promo_banners.dart';
import 'package:goodfellow/features/Home/screens/home/widgets/sticky_header.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/history.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true; // Track loading state
  bool isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _simulateLoading(); // Start loading simulation
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

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? APPColors.dark : APPColors.softgrey,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(), // This is important
          slivers: [
            // Sticky Header
            const SliverToBoxAdapter(
              child: Column(
                children: [
                  StickyHeader(),
                  SizedBox(height: APPSizes.spaceBtwItem),
                ],
              ),
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: APPSizes.defaultSpace / 1.5,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const OfflineText(),

                  const UpdateAvailable(),
                  const GreetingsCard(),
                  const SizedBox(height: APPSizes.spaceBtwItem / 2),
                  const Divider(),
                  const SizedBox(height: APPSizes.spaceBtwItem / 2),
                  // QuickServices(isRefreshing: isRefreshing),
                  const SizedBox(height: APPSizes.spaceBtwSections),

                  const SizedBox(height: APPSizes.spaceBtwSections),

                  const PromoBanners(),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  ElevatedButton(
                    onPressed: () {
                      checkDeviceInfo();
                    },
                    child: const Text("Manual Location Update"),
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  //const RecentTransactions(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkDeviceInfo() async {
    print("📍 Starting checkDeviceInfo...");

    final deviceStorage = GetStorage("setup");

    Map<String, String> getFallbackLocation() {
      final storedLat = deviceStorage.read('last_latitude') ?? "0.0";
      final storedLng = deviceStorage.read('last_longitude') ?? "0.0";
      print("⚠️ Using fallback location: $storedLat, $storedLng");
      return {"latitude": storedLat, "longitude": storedLng};
    }

    Future<Map<String, String>> getLocationSafely() async {
      try {
        // print("📡 Attempting to get current location...");
        final position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.low,
          // ignore: deprecated_member_use
          forceAndroidLocationManager: true,
        );
        // print(
        // "✅ Location retrieved: ${position.latitude}, ${position.longitude}");

        return {
          "latitude": position.latitude.toString(),
          "longitude": position.longitude.toString(),
        };
      } catch (e) {
        print("❌ Location error: $e");
        return getFallbackLocation();
      }
    }

    final locationInfo = await getLocationSafely();

    print("📦 Preparing location data...");
    final locationData = {
      'posdevice_id': deviceStorage.read('posdevice_id') ?? '',
      'latitude': locationInfo["latitude"]!,
      'longitude': locationInfo["longitude"]!,
      'timestamp': DateTime.now().toIso8601String(),
      'accuracy': "low",
      'region': '', // Optional: add reverse geocoding if needed
      'ip_address': '', // Remove if not needed anymore
      'city': '', // Optional: add reverse geocoding if needed
    };

    print("📤 Sending location data to: ${APIConstants.pinglocationendpoint}");
    print("📝 Payload: $locationData");

    final res = await APPHttpHelper.postMaster(
      APIConstants.pinglocationendpoint,
      '',
      locationData,
    );

    print("✅ Server Response: $res");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
