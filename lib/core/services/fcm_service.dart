import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'api_service.dart';

class FcmService {
  Future<void> saveToken({
    required int userId,
    required String token,
  }) async {
    try {
      debugPrint("========== KIRIM TOKEN ==========");
      debugPrint("USER ID : $userId");
      debugPrint("TOKEN   : $token");

      final response = await ApiService.dio.post(
        "/users/fcm-token",
        data: {
          "user_id": userId,
          "fcm_token": token,
        },
      );

      debugPrint("STATUS : ${response.statusCode}");
      debugPrint("BODY   : ${response.data}");

      debugPrint("========== BERHASIL ==========");

    } on DioException catch (e) {
      debugPrint("========== ERROR DIO ==========");
      debugPrint("STATUS : ${e.response?.statusCode}");
      debugPrint("BODY   : ${e.response?.data}");
      debugPrint("MESSAGE: ${e.message}");
    } catch (e) {
      debugPrint("========== ERROR ==========");
      debugPrint(e.toString());
    }
  }
}