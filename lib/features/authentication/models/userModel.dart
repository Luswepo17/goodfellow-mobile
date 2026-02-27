// To parse this JSON data, do
//
//     final userModule = userModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UserModule userModuleFromJson(String str) =>
    UserModule.fromJson(json.decode(str));

String userModuleToJson(UserModule data) => json.encode(data.toJson());

class UserModule {
  UserModule(
      {required this.firstname,
      required this.lastname,
      required this.username,
      required this.email,
      required this.password,
      required this.phonenumber,
      required this.nrc,
      this.isTnCsAgreed = true});

  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String phonenumber;
  String nrc;
  bool isTnCsAgreed;

  factory UserModule.fromJson(Map<String, dynamic> json) => UserModule(
      firstname: json["firstname"],
      lastname: json["lastname"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      phonenumber: json["phonenumber"],
      nrc: json["nrc"],
      isTnCsAgreed: json["isTnCsAgreed"]);

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "password": password,
        "phonenumber": phonenumber,
        "nrc": nrc,
        "isTnCsAgreed": isTnCsAgreed
      };
}
