import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:goodfellow/common/containers/app_rounded_container.dart';
import 'package:goodfellow/common/dialogs/custom_dialog.dart';
import 'package:goodfellow/features/Home/screens/transaction_history/history.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/constants/text_string.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:goodfellow/common/containers/transaction_dialog.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/Home/models/collection_model.dart';
import 'package:goodfellow/features/Home/screens/session_exp/session.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class CollectionController extends GetxController {
  static CollectionController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final amount = TextEditingController();
  late String collectionChannel;
  late String selectedCountryCode;
  // WebSocketChannel? channel;
  Timer? heartbeatTimer;
  Timer? pollingTimer;
  bool isSubscribed = false;
  int maxPollingAttempts = 30; // 5 minutes with 10-second intervals
  int currentPollingAttempts = 0;
  bool isWebSocketFailed = false;
  bool isListening = false;

  CollectionController({
    required this.collectionChannel,
    required this.selectedCountryCode,
  });

  GlobalKey<FormState> collectionFormKey = GlobalKey<FormState>();
  final deviceStorage = GetStorage();
}
