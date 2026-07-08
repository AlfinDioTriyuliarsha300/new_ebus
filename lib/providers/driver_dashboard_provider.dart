import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/driver_dashboard_service.dart';
import '../models/driver_dashboard_model.dart';

class DriverDashboardProvider extends ChangeNotifier {
  final DriverDashboardService _service =
      DriverDashboardService();

  bool isLoading = false;

  DriverDashboardModel? dashboard;

  Future<void> loadDashboard(int userId) async {
    isLoading = true;
    notifyListeners();

    try {
      dashboard =
          await _service.getDashboard(userId);

      if (dashboard != null &&
          dashboard!.busId != null) {

        final prefs =
            await SharedPreferences.getInstance();

        await prefs.setInt(
          "bus_id",
          dashboard!.busId!,
        );

        print(
          "BUS ID DISIMPAN = ${dashboard!.busId}",
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}