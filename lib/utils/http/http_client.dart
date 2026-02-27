import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:goodfellow/utils/constants/api_constants.dart';

class APPHttpHelper {
  static Future<Map<String, dynamic>> get(
    String url,
    String endpoint,
    String token,
  ) async {
    final response = await http
        .get(
          Uri.parse("$url/$endpoint"),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.acceptHeader: "application/json",
          },
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getMaster(
    String endpoint,
    String token,
  ) async {
    final response = await http
        .get(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.acceptHeader: "application/json",
          },
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String url,
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .post(
          Uri.parse("$url/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postMaster(
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .post(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> postwt(
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .post(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(
    String url,
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .put(
          Uri.parse("$url/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .patch(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(
    String url,
    String endpoint,
    String token,
  ) async {
    final response = await http
        .delete(
          Uri.parse("$url/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );

    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    // print(response.body);

    if (response.body.isEmpty) {
      throw FormatException("Empty response body");
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 408) {
      return {"status": "Timeout"};
    } else if (response.statusCode == 401) {
      final resBody = json.decode(response.body);

      return {
        "status": "failure",
        "code": "401",
        "error": "Invalid Credentials",
        "message": resBody["error"],
      };
    } else if (response.statusCode == 403) {
      final resBody = json.decode(response.body);
      return {
        "status": "failure",
        "code": "403",
        "error": "Unauthorized Access",
        "message": resBody["error"],
      };
    } else {
      var data = json.decode(response.body);
      return data;
      //throw Exception('${data["error"]}');
    }
  }

  static Future<List<dynamic>> getList(String endpoint, String token) async {
    final response = await http
        .get(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleListResponse(response);
  }

  static Future<List<dynamic>> postList(
    String endpoint,
    String token,
    dynamic data,
  ) async {
    final response = await http
        .post(
          Uri.parse("${APIConstants.publicUrl}/$endpoint"),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
          body: json.encode(data),
        )
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            return http.Response("Error", 408);
          },
        );
    return _handleListResponse(response);
  }

  static List<dynamic> _handleListResponse(http.Response response) {
    //print(json.decode(response.body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 408) {
      return [
        {"status": "Timeout"},
      ];
    } else {
      var data = json.decode(response.body);
      throw Exception('${data["error"]}');
    }
  }
}
