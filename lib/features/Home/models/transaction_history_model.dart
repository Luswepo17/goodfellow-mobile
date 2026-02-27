// To parse this JSON data, do
//
//     final TransactionHistoryModule = TransactionHistoryModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TransactionHistoryModule transactionHistoryModuleFromJson(String str) =>
    TransactionHistoryModule.fromJson(json.decode(str));

String transactionHistoryModuleToJson(TransactionHistoryModule data) =>
    json.encode(data.toJson());

class TransactionHistoryModule {
  TransactionHistoryModule({
    required this.startDate,
    required this.endDate,
  });

  String startDate;
  String endDate;

  factory TransactionHistoryModule.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryModule(
        startDate: json["startDate"],
        endDate: json["endDate"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
        "endDate": endDate,
      };
}
