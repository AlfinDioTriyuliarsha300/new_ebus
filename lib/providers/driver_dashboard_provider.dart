import 'package:flutter/material.dart';

import '../core/services/driver_dashboard_service.dart';
import '../models/driver_dashboard_model.dart';

class DriverDashboardProvider
    extends ChangeNotifier {

  final DriverDashboardService _service =
      DriverDashboardService();

  bool isLoading = false;

  DriverDashboardModel? dashboard;

  Future<void> loadDashboard(
      int userId) async {

    isLoading = true;
    notifyListeners();

    try {
      dashboard =
          await _service.getDashboard(userId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}