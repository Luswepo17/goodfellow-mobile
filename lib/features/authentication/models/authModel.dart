// To parse this JSON data, do
//
//     final loginModule = loginModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

LoginModule loginModuleFromJson(String str) =>
    LoginModule.fromJson(json.decode(str));

String loginModuleToJson(LoginModule data) => json.encode(data.toJson());

class LoginModule {
  LoginModule({
    required this.email,
    required this.password,
    required this.portal,
  });

  String email;
  String password;
  String portal;

  factory LoginModule.fromJson(Map<String, dynamic> json) => LoginModule(
    email: json["email"],
    password: json["password"],
    portal: json["portal"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "portal": portal,
  };
}
