class APIConstants {
  //static const String baseUrl = 'https://uat.insourceerp.com';
  // static const String baseUrl = 'https://uat-pos.mygeepay.com';
  static const String domain = "goodfellow.privatedns.org/v1";
  static const String publicUrl = 'https://$domain';
  static const String customerUrl = 'https://$domain/customer';

  static const String loginendpoint = "auth/login";
  static const String registerendpoint = "auth/register";
  static const String getPhoneTypesendpoint = "phone/type/get";

  static const String submitKyc = "kyc/create";
  static const String transactionStatusendpoint = "api/get-transaction-status";
  static const String getContractsendpoint = "contracts";
  static const String makePaymentendpoint = "payment/create";
  static const String checkTransactionStatus = "payment/status";
  static const String requesttopay = "api/payment/process";
  static const String payBill = "api/bill-payments/purchase";
  static const String transactiondetails = "api/transactions";
  static const String getBillCustomerName =
      "api/bill-payments/get-bill-customer";
  static const String purchasePackage = "api/bill-payments/purchase-voucher";
  static const String requestToPayPackages = "api/request-to-pay/";

  static const String deviceregistrationendpoint = "phone/create";

  static const String pinglocationendpoint = "location/register";
  static const String checkupdateendpoint = "app/update";
  //static const String mnostatusendpoint = "mno/status";
  static const String heartbeatendpoint = "pos/device/heartbeat";
  static const String transactiontimeoutendpoint = "portal/mmp/settimeout";
  static const String transactionstatusendpoint = "portal/mmp/txn/status";
  static const String narrationendpoint = "portal/mmp/narration";
  static const String transactiondetailsendpoint = "portal/mmp/txn/details/";
}
