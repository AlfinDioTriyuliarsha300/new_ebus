import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'api_service.dart';

class AuthService {
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await ApiService.dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
  }
}
