import 'package:flutter/foundation.dart';

class ApiConstants {
  // static const String baseUrl =
  //     'https://ebus-api-production.up.railway.app/api';

  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8080/api";
    }

    return "http://10.0.2.2:8080/api";
  }

  static const String login = "/users/login";
}
