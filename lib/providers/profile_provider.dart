import 'package:flutter/material.dart';

import '../core/services/profile_service.dart';
import '../models/user_model.dart';

class ProfileProvider
    extends ChangeNotifier {

  final ProfileService _service =
      ProfileService();

  UserModel? user;

  bool isLoading = false;

  Future<void> getProfile(
      int userId) async {

    try {

      isLoading = true;
      notifyListeners();

      user =
          await _service.getProfile(
        userId,
      );

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }
}