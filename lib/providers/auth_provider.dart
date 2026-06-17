import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/storage_keys.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;

  bool isLoggedIn = false;

  String? role;

  Future<void> login({required String email, required String password}) async {
    isLoading = true;

    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      isLoggedIn = true;
    } catch (e) {
      debugPrint(e.toString());
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
