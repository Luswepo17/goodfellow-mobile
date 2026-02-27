// To parse this JSON data, do
//
//     final StatusModule = StatusModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

StatusModule statusModuleFromJson(String str) =>
    StatusModule.fromJson(json.decode(str));

String statusModuleToJson(StatusModule data) => json.encode(data.toJson());

class StatusModule {
  StatusModule({
    required this.transactionid,
    required this.mno,
  });

  String transactionid;
  String mno;

  factory StatusModule.fromJson(Map<String, dynamic> json) => StatusModule(
        transactionid: json["transactionid"],
        mno: json["mno"],
      );

  Map<String, dynamic> toJson() => {
        "transactionid": transactionid,
        "mno": mno,
      };
}
