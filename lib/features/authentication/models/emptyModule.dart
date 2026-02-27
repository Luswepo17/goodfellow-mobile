// To parse this JSON data, do
//
//     final loginModule = loginModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

EmptyModule loginModuleFromJson(String str) =>
    EmptyModule.fromJson(json.decode(str));

String loginModuleToJson(EmptyModule data) => json.encode(data.toJson());

class EmptyModule {
  EmptyModule({
    required this.test,
  });

  String test;

  factory EmptyModule.fromJson(Map<String, dynamic> json) =>
      EmptyModule(test: json["test"]);

  Map<String, dynamic> toJson() => {"test": test,};
}
