// To parse this JSON data, do
//
//     final CollectionModule = CollectionModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CollectionModule collectionModuleFromJson(String str) =>
    CollectionModule.fromJson(json.decode(str));

String collectionModuleToJson(CollectionModule data) =>
    json.encode(data.toJson());

class CollectionModule {
  CollectionModule({
    required this.phoneNumber,
    required this.amount,
    required this.collectionChannel,
  });

  String phoneNumber;
  String amount;
  String collectionChannel;

  factory CollectionModule.fromJson(Map<String, dynamic> json) =>
      CollectionModule(
          phoneNumber: json["phone_number"],
          amount: json["amount"],
          collectionChannel: json['channel']);

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "amount": amount,
        "channel": collectionChannel,
      };
}
