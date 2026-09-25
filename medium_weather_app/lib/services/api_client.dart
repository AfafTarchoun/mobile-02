import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medium_weather_app/services/app_exception.dart';

abstract final class ApiClient {
  static const Duration _timeout = Duration(seconds: 10);

  static const String connectionFailed =
      'The service connection is lost, please check your internet connection '
      'or try again later.';

  static Future<Map<String, dynamic>> getJson(Uri uri) async {
    final http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } on TimeoutException {
      throw const AppException(connectionFailed);
    } catch (_) {
      throw const AppException(connectionFailed);
    }

    if (response.statusCode != 200) {
      throw const AppException(connectionFailed);
    }

    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const AppException(connectionFailed);
    }
  }
}
