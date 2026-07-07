import 'package:dio/dio.dart';

import '../../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  Future<UserModel> login({
    required String email,
    required String password,
    required String device,
  }) async {
    try {
      Response response = await ApiService.dio.post(
      '/users/login',
      data: {
        'email': email,
        'password': password,
        'device': device,
      },
    );

    print("LOGIN RESPONSE");
    print(response.data);

      if (response.data['success']) {
        return UserModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
