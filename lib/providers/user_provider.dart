import 'package:flutter/material.dart';

import '../core/services/user_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service = UserService();

  bool isLoading = false;

  List<UserModel> users = [];

  Future<void> getUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      users = await _service.getUsers();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(int userId, String password) async {
    await _service.resetPassword(userId, password);
  }

  Future<void> createUser({
    required String email,

    required String password,

    required String role,

    required int companyId,
  }) async {
    await _service.createUser(
      email: email,

      password: password,

      role: role,

      companyId: companyId,
    );

    await getUsers();
  }

  Future<void> updateUser({
    required int id,
    required String email,
    required String role,
    required int companyId,
  }) async {
    await _service.updateUser(
      id: id,

      email: email,

      role: role,

      companyId: companyId,
    );
    await getUsers();
  }

  Future<void> deleteUser(int id) async {
    await _service.deleteUser(id);

    await getUsers();
  }
}
