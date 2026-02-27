// To parse this JSON data, do
//
//     final ResetPasswordModule = ResetPasswordModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ResetPasswordModule resetPasswordModuleFromJson(String str) =>
    ResetPasswordModule.fromJson(json.decode(str));

String resetPasswordModuleToJson(ResetPasswordModule data) =>
    json.encode(data.toJson());

class ResetPasswordModule {
  ResetPasswordModule({
    required this.oldPassword,
    required this.newPassword,
  });

  String oldPassword;
  String newPassword;

  factory ResetPasswordModule.fromJson(Map<String, dynamic> json) =>
      ResetPasswordModule(
        oldPassword: json["oldPassword"],
        newPassword: json["newPassword"],
      );

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
}
