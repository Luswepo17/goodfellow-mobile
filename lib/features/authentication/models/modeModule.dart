// To parse this JSON data, do
//
//     final ModeModule = ModeModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ModeModule modeModuleFromJson(String str) =>
    ModeModule.fromJson(json.decode(str));

String modeModuleToJson(ModeModule data) => json.encode(data.toJson());

class ModeModule {
  ModeModule({
    required this.phoneNumber,
    required this.amount,
    required this.collectionChannel,
  });

  String phoneNumber;
  String amount;
  String collectionChannel;

  factory ModeModule.fromJson(Map<String, dynamic> json) => ModeModule(
      phoneNumber: json["phone_number"],
      amount: json["amount"],
      collectionChannel: json['channel']);

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "amount": amount,
        "channel": collectionChannel,
      };
}
