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

  final List<GeofenceHistory> geofenceHistory = [];

  bool followBus = true;

  String? lastGeofenceMessage;

  // ==========================
  // GEOFENCE EVENT
  // ==========================

  String? lastGeofenceZone;

  String? lastGeofenceStatus;

  /// Event geofence terbaru.
  String? latestGeofenceMessage;
  int? estimatedArrival;

  String get etaStatus {
    if (trackingData == null) {
      return "-";
    }

    // Tracking mati
    if (!trackingData!.bus.tracking) {
      return "Tracking tidak aktif";
    }

    // Sudah sampai
    if (trackingData!.location.progress >= 100) {
      return "Bus telah tiba";
    }

    // Hampir tiba
    if (trackingData!.location.remainingDistance <= 0.5) {
      return "Bus hampir tiba";
    }

    // Bus berhenti
    if (trackingData!.location.speed <= 1) {
      return "Bus sedang berhenti";
    }

    return estimatedArrival == null
    ? "-"
    : "$estimatedArrival menit";
  }

  Color get etaColor {
    if (trackingData == null) {
      return Colors.grey;
    }

    if (!trackingData!.bus.tracking) {
      return Colors.grey;
    }

    if (trackingData!.location.progress >= 100) {
      return Colors.green;
    }

    if (trackingData!.location.remainingDistance <= 0.5) {
      return Colors.orange;
    }

    if (trackingData!.location.speed <= 1) {
      return Colors.red;
    }

    return Colors.blue;
  }

  void enableFollowBus() {
    followBus = true;
    notifyListeners();
  }

  void disableFollowBus() {
    followBus = false;
    notifyListeners();
  }

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

      updateEstimatedArrival();
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

    //-----------------------------------
    // OLD GEOFENCE
    //-----------------------------------

    final oldZone = trackingData!.location.currentZone;
    final oldStatus = trackingData!.location.currentZoneStatus;

    //-----------------------------------
    // UPDATE LOCATION
    //-----------------------------------

    trackingData!.location.updateFromSocket(data);

    //-----------------------------------
    // UPDATE BUS
    //-----------------------------------

    trackingData!.bus.status =
        data["status"]?.toString() ?? trackingData!.bus.status;

    trackingData!.bus.progress =
        double.tryParse(
          (data["progress"] ?? trackingData!.bus.progress).toString(),
        ) ??
        trackingData!.bus.progress;

    //-----------------------------------
    // UPDATE GEOFENCE
    //-----------------------------------

    trackingData!.location.currentZone =
        data["current_zone"]?.toString() ?? trackingData!.location.currentZone;

    trackingData!.location.currentZoneStatus =
        data["current_zone_status"]?.toString() ??
        trackingData!.location.currentZoneStatus;

    if (oldZone != trackingData!.location.currentZone ||
        oldStatus != trackingData!.location.currentZoneStatus) {
      lastGeofenceMessage = _buildGeofenceMessage(
        trackingData!.location.currentZone,
        trackingData!.location.currentZoneStatus,
      );
    }

    trackingData!.bus.currentZone =
        data["current_zone"]?.toString() ?? trackingData!.bus.currentZone;

    trackingData!.bus.currentZoneStatus =
        data["current_zone_status"]?.toString() ??
        trackingData!.bus.currentZoneStatus;

    //-----------------------------------
    // UPDATE TIME
    //-----------------------------------

    trackingData!.location.updatedAt =
        data["updated_at"]?.toString() ?? trackingData!.location.updatedAt;

    //-----------------------------------
    // UPDATE ETA
    //-----------------------------------

    updateEstimatedArrival();

    //-----------------------------------
    // DETECT GEOFENCE CHANGE
    //-----------------------------------

    final newZone = trackingData!.location.currentZone;
    final newStatus = trackingData!.location.currentZoneStatus;

    if (oldZone != newZone || oldStatus != newStatus) {
      lastGeofenceZone = oldZone;
      lastGeofenceStatus = oldStatus;

      latestGeofenceMessage = "$newStatus:$newZone";

      geofenceHistory.insert(
        0,
        GeofenceHistory(
          zone: newZone ?? "-",
          status: newStatus ?? "-",
          time: DateTime.now(),
        ),
      );

      // Maksimal simpan 20 riwayat
      if (geofenceHistory.length > 20) {
        geofenceHistory.removeLast();
      }
    }

    notifyListeners();
  }

  String _buildGeofenceMessage(String? zone, String? status) {
    if (zone == null || status == null) {
      return "Status geofence berubah";
    }

    switch (status.toLowerCase()) {
      case "enter":
        return "🟢 Bus memasuki $zone";

      case "inside":
        return "📍 Bus berada di $zone";

      case "exit":
        return "🔴 Bus meninggalkan $zone";

      case "arrived":
        return "🏁 Bus telah tiba di $zone";

      default:
        return "📍 $status : $zone";
    }
  }

  void updateEstimatedArrival() {
    if (trackingData == null) return;

    estimatedArrival = trackingData!.calculateEstimatedArrival();
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

class GeofenceHistory {
  final String zone;
  final String status;
  final DateTime time;

  GeofenceHistory({
    required this.zone,
    required this.status,
    required this.time,
  });
}
