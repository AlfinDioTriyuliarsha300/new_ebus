import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../core/services/passenger_tracking_service.dart';
import '../core/services/socket_service.dart';
import '../models/passenger_tracking_model.dart';

class PassengerTrackingProvider extends ChangeNotifier {
  final PassengerTrackingService _service = PassengerTrackingService();

  final SocketService _socket = SocketService.instance;

  PassengerTrackingModel? trackingData;

  bool isLoading = false;

  String? errorMessage;

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

    errorMessage = null;

    notifyListeners();

    try {
      trackingData = await _service.getTracking(ticket);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> startRealtime(String ticket) async {
    await loadTracking(ticket);

    _socket.connect();

    _socket.socket?.off("bus_location");

    _socket.socket?.on("bus_location", (data) {
      _onSocketUpdate(data);
    });
  }

  void _onSocketUpdate(dynamic data) {
    if (trackingData == null) {
      return;
    }

    if (data["bus_id"] != trackingData!.bus.id) {
      return;
    }

    trackingData!.location.updateFromSocket(data);

    //-----------------------------------
    // UPDATE STATUS BUS
    //-----------------------------------

    trackingData!.bus.status = data["status"] ?? trackingData!.bus.status;

    trackingData!.bus.progress = (data["progress"] ?? trackingData!.bus.progress).toDouble();

    notifyListeners();
  }

  void stopRealtime() {
    _socket.socket?.off("bus_location");

    _socket.disconnect();
  }

  @override
  void dispose() {
    stopRealtime();

    super.dispose();
  }
}
