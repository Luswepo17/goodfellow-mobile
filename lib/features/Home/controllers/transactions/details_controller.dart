import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class TransactionController extends GetxController {
  final deviceStorage = GetStorage();

  RxBool isLoading = true.obs;
  RxString txnType = ''.obs;
  RxString status = ''.obs;
  RxString date = ''.obs;
  RxString phone = ''.obs;
  RxString paymentChannel = ''.obs;
  RxString currency = ''.obs;
  RxString amount = ''.obs;
  RxString zescoToken = ''.obs;
  RxString units = ''.obs;
  RxString totalVat = ''.obs;
  RxString kwhAmount = ''.obs;
  RxString customerName = ''.obs;
  RxString voucherSerial = ''.obs;
  RxString customerAddress = ''.obs;

  final String transactionId;

  TransactionController({required this.transactionId});

  @override
  void onInit() {
    super.onInit();

    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    isLoading.value = true;
    final token = deviceStorage.read("token");
    final endpoint = "${APIConstants.transactiondetails}/$transactionId";

    try {
      final res = await APPHttpHelper.get("", endpoint, token);
      txnType.value = res['transaction']['transaction_type'] ?? "";
      currency.value = res['transaction']['currency'] ?? "";
      paymentChannel.value = res['transaction']['payment_channel'] ?? "";
      amount.value = res['transaction']["amount"] ?? "";
      date.value = res['transaction']["created_at"] != null
          ? APPHelperFunctions.parseIsoDate(
              res['transaction']["created_at"],
            ).toString()
          : "No Date Available";
      status.value = res['transaction']["status"] ?? "";
      phone.value = res['transaction']["customer"] ?? "";

      final metadata = res["transaction"]?["meta_data"];
      if (metadata != null) {
        zescoToken.value = metadata["token"]?.toString() ?? "";
        units.value = metadata["units"]?.toString() ?? "";
        totalVat.value = metadata["total_vat"]?.toString() ?? "";
        kwhAmount.value = metadata["kwh_amount"]?.toString() ?? "";
        customerName.value = metadata["customer_name"] ?? "";
        customerAddress.value = metadata["customer_address"] ?? "";
        voucherSerial.value = metadata["voucher_serial"] ?? "";
      }
    } finally {
      isLoading.value = false;
    }
  }
}
