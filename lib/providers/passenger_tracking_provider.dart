import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../core/services/passenger_tracking_service.dart';
import '../models/passenger_tracking_model.dart';

class PassengerTrackingProvider extends ChangeNotifier {
  final PassengerTrackingService _service = PassengerTrackingService();

  PassengerTrackingModel? trackingData;

  bool isLoading = false;

  Timer? _timer;

  // ==========================
  // BUS LOCATION
  // ==========================

  LatLng? get busLocation {
    if (trackingData == null) {
      return null;
    }

    return LatLng(trackingData!.location.lat, trackingData!.location.lng);
  }

  Future<void> loadTracking(String ticket) async {
    isLoading = true;

    notifyListeners();

    try {
      trackingData = await _service.getTracking(ticket);
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;

    notifyListeners();
  }

  void startRealtime(String ticket) {
    _timer?.cancel();

    loadTracking(ticket);

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadTracking(ticket);
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
