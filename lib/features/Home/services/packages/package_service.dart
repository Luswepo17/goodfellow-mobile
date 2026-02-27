import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:goodfellow/utils/http/http_client.dart';

class PackageService {
  final GetStorage deviceStorage = GetStorage();

  Future<Map<String, dynamic>> fetchCustomerDetails(
    String accountNumber,
    String channelCode,
  ) async {
    try {
      final token = deviceStorage.read("token");
      var body = {
        "account_number": accountNumber.trim(),
        "channel_code": channelCode,
      };

      var response = await APPHttpHelper.post(
        "",
        APIConstants.getBillCustomerName,
        token,
        body,
      );
      return response;
    } catch (e) {
      throw Exception(e.toString().substring(10));
    }
  }

  Future<Map<String, dynamic>> makePackagePurchase(
    String accountNumber,
    String packageCode,
  ) async {
    var body = {"recipient": accountNumber.trim(), "package_code": packageCode};

    final token = deviceStorage.read("token");
    return await APPHttpHelper.post(
      "",
      APIConstants.purchasePackage,
      token,
      body,
    );
  }
}
