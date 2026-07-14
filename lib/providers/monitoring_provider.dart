import 'package:flutter/material.dart';
import 'dart:async';

import '../core/services/monitoring_service.dart';
import '../models/bus_location_model.dart';

class MonitoringProvider extends ChangeNotifier {
  final MonitoringService _service = MonitoringService();

  bool isLoading = false;

  List<BusLocationModel> buses = [];

  Timer? _timer;

  Future<void> getLocations(int companyId, {bool refresh = false}) async {
    if (!refresh) {
      isLoading = true;

      notifyListeners();
    }

    buses = await _service.getLocations(companyId);

    if (!refresh) {
      isLoading = false;
    }

    notifyListeners();
  }

  void startRealtime(int companyId) {
    _timer?.cancel();

    getLocations(companyId);

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      getLocations(companyId);
    });
  }

  void stopRealtime() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}
