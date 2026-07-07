import 'package:flutter/material.dart';

import '../core/services/monitoring_service.dart';
import '../models/bus_location_model.dart';

class MonitoringProvider
    extends ChangeNotifier {

  final MonitoringService _service =
      MonitoringService();

  bool isLoading=false;

  List<BusLocationModel> buses=[];

  Future<void> getLocations(
      int companyId) async {

    isLoading=true;
    notifyListeners();

    buses =
      await _service.getLocations(
        companyId
      );

    isLoading=false;
    notifyListeners();
  }
}