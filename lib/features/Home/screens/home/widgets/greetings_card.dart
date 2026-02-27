import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';

class GreetingsCard extends StatefulWidget {
  const GreetingsCard({super.key});

  @override
  State<GreetingsCard> createState() => _GreetingsCardState();
}

class _GreetingsCardState extends State<GreetingsCard> {
  final deviceStorage = GetStorage();
  late String greeting = '';
  String businessName = "";
  String branchName = "";
  String userName = "";
  String date = "";
  String timeCurrent = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    setData();
    updateDateTime(); // Initial update
    _startTimer(); // Start the timer
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when widget is disposed
    super.dispose();
  }

  void setData() {
    final businessNameData = deviceStorage.read('businessName') ?? "";
    final branchNameData = deviceStorage.read('branchName') ?? "";
    final userNameData = deviceStorage.read('userName') ?? "";

    setState(() {
      userName = userNameData;
      branchName = branchNameData;
      businessName = businessNameData;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    final now = DateTime.now();

    setState(() {
      timeCurrent = DateFormat.jm().format(
        now,
      ); // 12-hour format, e.g., 10:30 AM
      date = DateFormat.MMMd().format(now); // e.g., November 12
      updateGreeting(now.hour);
    });
  }

  void updateGreeting(int hour) {
    if (hour < 12) {
      greeting = 'Good Morning ';
    } else if (hour >= 12 && hour <= 16) {
      greeting = 'Good Afternoon 🌞';
    } else if (hour > 16 && hour < 20) {
      greeting = 'Good Evening 🌇';
    } else {
      greeting = "It's Night Time 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: APPHelperFunctions.isDarkMode(context)
          ? APPColors.darkerGrey
          : APPColors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(APPSizes.spaceBtwItem),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: APPSizes.spaceBtwItem / 2),
                  Text(
                    greeting,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    userName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    children: [
                      if (branchName.isNotEmpty)
                        SizedBox(
                          width: 100,
                          child: Text(
                            businessName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      if (branchName.isEmpty)
                        SizedBox(
                          width: APPHelperFunctions.screenWidth() / 2,
                          child: Text(
                            businessName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      if (branchName.isNotEmpty) const Text(" > "),
                      Text(
                        branchName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  date,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  timeCurrent,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
