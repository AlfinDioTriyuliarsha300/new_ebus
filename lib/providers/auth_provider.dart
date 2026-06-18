import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/storage_keys.dart';
import '../core/services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;

  bool isLoggedIn = false;

  String? role;

  UserModel? currentUser;

  Future<void> login({required String email, required String password}) async {
    final device = kIsWeb ? "web" : "mobile";
    isLoading = true;

    notifyListeners();

    try {
      currentUser = await _authService.login(
        email: email,

        password: password,

        device: device,
      );

      await saveLogin(
        userId: currentUser!.id,

        email: currentUser!.email,

        role: currentUser!.role,
      );

      isLoggedIn = true;

      role = currentUser!.role;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> saveLogin({
    required int userId,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(StorageKeys.userId, userId);

    await prefs.setString(StorageKeys.email, email);

    await prefs.setString(StorageKeys.role, role);

    await prefs.setBool('is_logged_in', true);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    isLoggedIn = false;

    notifyListeners();
  }
}
