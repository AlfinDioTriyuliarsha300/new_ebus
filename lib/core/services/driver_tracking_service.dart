import 'package:dio/dio.dart';

import '../../models/driver_tracking_model.dart';
import 'api_service.dart';

class DriverTrackingService {
  /*
  ===========================================
  GET TRACKING
  ===========================================
  */

  Future<DriverTrackingModel?> getDashboard(
    int busId,
  ) async {
    try {
      final response = await ApiService.dio.get(
        "/driver/tracking/$busId",
      );

      if (response.data["success"] == true) {
        return DriverTrackingModel.fromJson(
          response.data,
        );
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /*
  ===========================================
  START TRACKING
  ===========================================
  */

  Future<void> startTracking(
    int driverId,
  ) async {
    await ApiService.dio.post(
      "/driver/tracking/start",
      data: {
        "driverId": driverId,
      },
    );
  }

  /*
  ===========================================
  STOP TRACKING
  ===========================================
  */

  Future<void> stopTracking(
    int driverId,
  ) async {
    await ApiService.dio.post(
      "/driver/tracking/stop",
      data: {
        "driverId": driverId,
      },
    );
  }

  /*
  ===========================================
  UPDATE LOCATION
  ===========================================
  */

  Future<void> sendLocation(
    int driverId,
    double lat,
    double lng,
    double speed,
  ) async {

    await ApiService.dio.post(
      "/location/update",

      data: {

        "driver_id": driverId,

        "latitude": lat,

        "longitude": lng,

        "speed": speed,
      },
    );
  }
}