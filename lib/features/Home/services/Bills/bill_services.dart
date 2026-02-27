import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class BillPurchaseService {
  final GetStorage deviceStorage = GetStorage();

  Future<Map<String, dynamic>> getCustomerDetails({
    required String accountNumber,
    required String channelCode,
  }) async {
    final token = deviceStorage.read("token");
    var body = {
      "account_number": accountNumber.trim(),
      "channel_code": channelCode,
    };

    return await APPHttpHelper.post(
      "",
      APIConstants.getBillCustomerName,
      token,
      body,
    );
  }

  Future<Map<String, dynamic>> makeBillPayment({
    required String accountNumber,
    required String amount,
    required String channelCode,
  }) async {
    final token = deviceStorage.read("token");
    var body = {
      "accountNumber": accountNumber.trim(),
      "amount": amount,
      "channel_code": channelCode,
    };

    return await APPHttpHelper.post("", APIConstants.payBill, token, body);
  }
}
