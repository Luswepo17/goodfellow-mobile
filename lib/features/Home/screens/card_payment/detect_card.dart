import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/common/appbar/appbar.dart';
import 'package:goodfellow/common/images/app_rounded_image.dart';
import 'package:goodfellow/data/services/card_detection_service.dart';
import 'package:goodfellow/features/Home/screens/home/home.dart';
import 'package:goodfellow/utils/constants/image_strings.dart';
import 'package:goodfellow/utils/constants/sizes.dart';

class CardDetectionScreen extends StatefulWidget {
  const CardDetectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardDetectionScreenState createState() => _CardDetectionScreenState();
}

class _CardDetectionScreenState extends State<CardDetectionScreen> {
  bool isDetecting = false;
  String cardDetails = "No card detected.";

  @override
  void initState() {
    super.initState();
    CardDetectionService.start();
    CardDetectionService.setOnCardDetectedCallback(updateCardDetails);
    startDetection();
  }

  void startDetection() async {
    setState(() {
      isDetecting = true;
      cardDetails = "Detecting card...";
    });

    //showDialog();
    showLoadingDialog();

    try {
      // Introduce a delay if necessary before starting the detection
      // await Future.delayed(const Duration(seconds: 7));
      await CardDetectionService.startCardDetection();
    } catch (e) {
      setState(() {
        cardDetails = "Error detecting card: $e";
      });
    } finally {
      //if (isDetecting) Navigator.of(context).pop();
    }
  }

  void stopDetection() async {
    await CardDetectionService.stopCardDetection();
    setState(() {
      isDetecting = false;
      cardDetails = "Card detection stopped.";
    });
    // Get.back();
  }

  void updateCardDetails(String cardNumber) {
    // print("Flutter: updateCardDetails called with cardNumber: $cardNumber");

    setState(() {
      cardDetails = "Card detected: $cardNumber";
      isDetecting = false;
    });

    // if (Navigator.canPop(context)) Navigator.of(context).pop();
  }

  // void showDialog() {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
  //     barrierColor: Colors.black54, // Background color for the dialog
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (BuildContext buildContext, Animation<double> animation,
  //         Animation<double> secondaryAnimation) {
  //       return Dialog(
  //         backgroundColor: APPHelperFunctions.isDarkMode(context)
  //             ? APPColors.dark.withOpacity(0.9)
  //             : APPColors.white.withOpacity(0.9),
  //         child: Padding(
  //           padding: const EdgeInsets.all(APPSizes.defaultSpace),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 "Detecting Card",
  //                 style: Theme.of(context).textTheme.bodyLarge,
  //               ),
  //               const SizedBox(height: APPSizes.spaceBtwSections),
  //               LoadingAnimationWidget.threeArchedCircle(
  //                 color: APPColors.primary,
  //                 size: 50,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return FadeTransition(
  //         opacity: animation, // Adds the fade-in and fade-out effect
  //         child: SlideTransition(
  //           position: Tween<Offset>(
  //             begin: const Offset(0, 1), // Start from the bottom
  //             end: Offset.zero, // Slide to the center
  //           ).animate(CurvedAnimation(
  //             parent: animation,
  //             curve: Curves.easeOut,
  //           )),
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Detecting card..."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: APPAPPBar(
        showBackArrow: true,
        onBackPressed: () {
          Get.to(() => const HomeScreen());
        },
        title: Text(
          "Card Detection",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const APPRoundedImage(imageUrl: APPImages.cardBg),
            const SizedBox(height: APPSizes.spaceBtwSections),
            Text(
              cardDetails,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: APPSizes.spaceBtwItem),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isDetecting ? stopDetection : startDetection,
                child: Text(isDetecting ? "Stop Detection" : "Retry"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
