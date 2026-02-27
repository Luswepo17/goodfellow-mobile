// To parse this JSON data, do
//
//     final DeviceModule = DeviceModuleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

DeviceModule deviceModuleFromJson(String str) =>
    DeviceModule.fromJson(json.decode(str));

String deviceModuleToJson(DeviceModule data) => json.encode(data.toJson());

class DeviceModule {
  DeviceModule({
    required this.merchantID,
    required this.deviceName,
    required this.serialNumber,
    required this.location,
  });

  String merchantID;
  String deviceName;
  String serialNumber;
  String location;

  factory DeviceModule.fromJson(Map<String, dynamic> json) => DeviceModule(
        merchantID: json["merchantID"],
        deviceName: json["deviceName"],
        serialNumber: json["serialNumber"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "merchantID": merchantID,
        "deviceName": deviceName,
        "serialNumber": serialNumber,
        "location": location,
      };
}
