import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../core/services/driver_tracking_service.dart';
import '../models/driver_tracking_model.dart';

class DriverTrackingProvider extends ChangeNotifier {
  final DriverTrackingService _service = DriverTrackingService();

  DriverTrackingModel? trackingData;

  Position? currentPosition;

  LatLng? busLocation;

  bool isLoading = false;

  bool isTracking = false;

  Timer? _timer;

  StreamSubscription<Position>? _positionStream;

  /*
  ==========================
  LOAD TRACKING
  ==========================
  */

  Future<void> loadBusLocation(int busId) async {
    isLoading = true;

    notifyListeners();

    try {
      trackingData = await _service.getDashboard(busId);

      if (trackingData != null) {
        busLocation = LatLng(
          trackingData!.location.lat,

          trackingData!.location.lng,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;

    notifyListeners();
  }

  /*
  ==========================
  START TRACKING
  ==========================
  */

  Future<void> startTracking(int driverId) async {
    await _service.startTracking(driverId);

    isTracking = true;

    notifyListeners();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    _positionStream?.cancel();

    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,

            distanceFilter: 5,
          ),
        ).listen((Position position) async {
          currentPosition = position;

          busLocation = LatLng(position.latitude, position.longitude);

          notifyListeners();

          print("========== GPS ==========");
          print(position.latitude);
          print(position.longitude);
          print(position.speed);
          print(position.heading);

          print("SEND TO SERVER");

          await _service.sendLocation(
            driverId: driverId,

            latitude: position.latitude,

            longitude: position.longitude,

            speed: position.speed,

            heading: position.heading,

            accuracy: position.accuracy,
          );
        });
  }

  /*
  ==========================
  STOP TRACKING
  ==========================
  */

  Future<void> stopTracking(int driverId) async {
    await _service.stopTracking(driverId);

    await _positionStream?.cancel();

    _positionStream = null;

    isTracking = false;

    notifyListeners();
  }

  /*
  ==========================
  CURRENT LOCATION
  ==========================
  */

  Future<void> getCurrentLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );

    notifyListeners();
  }

  /*
  ==========================
  REALTIME
  ==========================
  */

  void startRealtime(int busId) {
    _timer?.cancel();

    loadBusLocation(busId);

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadBusLocation(busId);
    });
  }

  /*
  ==========================
  STOP REALTIME
  ==========================
  */

  void stopRealtime() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();

    _positionStream?.cancel();

    super.dispose();
  }
}
