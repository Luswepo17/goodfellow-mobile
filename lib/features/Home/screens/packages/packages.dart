import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/text/offline_text.dart';
import 'package:goodfellow/features/Home/screens/packages/widgets/one_package.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({
    super.key,
    required this.packageCode,
    required this.name,
    required this.channelCode,
  });

  final String packageCode;
  final String name;
  final String channelCode;

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<Map<String, dynamic>> packages = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getPackages();
  }

  Future<void> getPackages() async {
    final deviceStorage = GetStorage();

    final token = deviceStorage.read("token");

    final url =
        "https://supervisor.mygeepay.com/api/request-to-pay/${widget.packageCode}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          final fetchedPackages = List<Map<String, dynamic>>.from(
            data["channel"]["packages"],
          );
          //  print(fetchedPackages);

          setState(() {
            packages = fetchedPackages;
            isLoading = false;
            if (packages.isEmpty) {
              errorMessage = "No Packages available at the moment";
            }
          });
        } else {
          setState(() {
            errorMessage = data["message"];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to load packages. Try again later.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return SafeArea(
      child: Scaffold(
        appBar: APPAPPBar(
          title: Text(
            widget.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          showBackArrow: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(APPSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OfflineText(),
                  Text(
                    "Here you can view all the packages for ${widget.name}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwSections),
                  isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: APPSizes.appBarHeight,
                          ),
                          child: Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              size: 50,
                              color: APPColors.primary,
                            ),
                          ),
                        )
                      : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : PackageCard(
                          packages: packages,
                          dark: dark,
                          channelCode: widget.channelCode,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PackageCard extends StatelessWidget {
  const PackageCard({
    super.key,
    required this.packages,
    required this.dark,
    required this.channelCode,
  });

  final List<Map<String, dynamic>> packages;
  final bool dark;
  final String channelCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: packages.map((package) {
        return GestureDetector(
          onTap: () {
            Get.to(
              () => OnePackageScreen(
                packageCode: package["package_code"],
                packagePrice: package['price'],
                packageName: package["name"],
                channelCode: channelCode, // Fixed
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: APPSizes.spaceBtwItem),
            child: Card(
              elevation: 5,
              color: dark ? APPColors.dark : APPColors.white,
              child: Padding(
                padding: const EdgeInsets.all(APPSizes.defaultSpace),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        package["name"],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "K${package["price"]}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
