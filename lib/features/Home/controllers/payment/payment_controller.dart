import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/helpers/network_manager.dart';
import 'package:goodfellow/utils/http/http_client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentController extends GetxController {
  static PaymentController get instance => Get.find();

  final phone = TextEditingController();
  final isLoading = false.obs;
  final amount = TextEditingController();
  final phoneError = false.obs;
  final amountError = false.obs;
  final isFormValid = false.obs;

  GlobalKey<FormState> signinFormKey = GlobalKey<FormState>();

  final deviceStorage = GetStorage();

  // Payment Status Tracking
  final paymentStatus = 'pending'.obs;
  final paymentMessage = 'Initializing payment...'.obs;
  final isCheckingStatus = false.obs;
  Timer? _statusTimer;

  Future<void> makeCollection(String installmentId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;
      if (!signinFormKey.currentState!.validate()) return;

      final deviceStorage = GetStorage();
      final token = deviceStorage.read("token");
      final phoneId = deviceStorage.read("phone_id");
      final userId = deviceStorage.read("user_id");

      isLoading.value = true;
      phoneError.value = false;
      amountError.value = false;

      final body = {
        "phone": "260${phone.text}",
        "amount": amount.text,
        "installment_id": installmentId,
        "phone_id": phoneId,
        "user_id": userId,
      };

      var res = await APPHttpHelper.post(
        APIConstants.publicUrl,
        APIConstants.makePaymentendpoint,
        token,
        body,
      );

      print("Response: ${res}");
      if (res['status'] == "success") {
        final data = res["data"];
        final String status = data['status'] ?? 'pending';
        final String? transactionRef = data['data'] != null
            ? data['data']['transaction_reference']
            : null;

        if (status == 'successful') {
          isLoading.value = false;
          APPLoaders.successSnackBar(
            title: "Payment Successful",
            message:
                res["message"] ?? "Your payment was completed successfully.",
          );
          return;
        }

        if (transactionRef != null) {
          _showStatusDialog();
          _startStatusPolling(transactionRef, token);
        } else {
          isLoading.value = false;
          APPLoaders.successSnackBar(
            title: "Payment Requested",
            message:
                res["message"] ??
                "Payment request sent. Awaiting customer action.",
          );
        }
        return;
      } else if (res['error'] != null) {
        if (res["code"] == "401") {
          phoneError.value = true;
          amountError.value = true;
          isLoading.value = false;
          throw Exception(res["error"]);
        } else if (res["code"] == "403") {
          isLoading.value = false;
          throw Exception(res["message"]);
        } else {
          isLoading.value = false;
          throw Exception(res["error"]);
        }
      }
    } catch (exception) {
      isLoading.value = false;
      //  APPFullScreenLoader.stopLoader();
      APPLoaders.errorSnackBar(
        title: "Oh snap!",
        message: exception.toString().substring(11),
      );
    }
  }

  void _showStatusDialog() {
    paymentStatus.value = 'pending';
    paymentMessage.value =
        'Payment initiated. Please check your phone for the M-Pesa prompt.';
    isCheckingStatus.value = true;

    Get.defaultDialog(
      title: "Payment Status",
      barrierDismissible: false,
      content: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCheckingStatus.value)
              LoadingAnimationWidget.threeArchedCircle(
                color: APPColors.primary,
                size: 50,
              )
            else if (paymentStatus.value == 'successful')
              const Icon(Icons.check_circle, color: Colors.green, size: 60)
            else
              const Icon(Icons.error, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text(
              paymentMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      confirm: Obx(
        () => !isCheckingStatus.value
            ? ElevatedButton(
                onPressed: () {
                  Get.back();
                  isLoading.value = false;
                },
                child: const Text("Close"),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  void _startStatusPolling(String transactionRef, String token) {
    _statusTimer?.cancel();
    int count = 0;
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      count++;
      if (count >= 120) {
        // 10 minutes timeout
        timer.cancel();
        isCheckingStatus.value = false;
        paymentStatus.value = 'timeout';
        paymentMessage.value =
            "Payment check timed out. Please check your transaction history.";
        return;
      }

      try {
        final res = await APPHttpHelper.get(
          APIConstants.publicUrl,
          "${APIConstants.checkTransactionStatus}/$transactionRef",
          token,
        );

        if (res['status'] == 'success') {
          final data = res['data'];
          final String status = data['status'] ?? 'pending';

          if (status == 'successful') {
            timer.cancel();
            isCheckingStatus.value = false;
            paymentStatus.value = 'successful';
            paymentMessage.value = "Payment was successful! Thank you.";
            APPLoaders.successSnackBar(
              title: "Success",
              message: "Payment completed successfully",
            );
          } else if (status == 'failed') {
            timer.cancel();
            isCheckingStatus.value = false;
            paymentStatus.value = 'failed';
            paymentMessage.value = "Payment failed. Please try again.";
            APPLoaders.errorSnackBar(
              title: "Payment Failed",
              message: "Transaction was not successful",
            );
          } else {
            paymentMessage.value = "Status: $status. Awaiting confirmation...";
          }
        }
      } catch (e) {
        print("Error polling status: $e");
      }
    });
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    super.onClose();
  }
}
