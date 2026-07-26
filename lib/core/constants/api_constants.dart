import 'package:flutter/foundation.dart';

class ApiConstants {

  static const bool useRailway = true;

  static String get baseUrl {

    if (useRailway) {
      return "https://newebusbackend-production-9bec.up.railway.app/api";
    }

    if (kIsWeb) {
      return "http://localhost:8080/api";
    }

    return "http://10.0.2.2:8080/api";
  }

  static const String login = "/users/login";
}