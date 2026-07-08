import 'package:dio/dio.dart';

import '../../models/driver_tracking_model.dart';
import 'api_service.dart';

class DriverTrackingService {

  Future<DriverTrackingModel?> getDashboard(
    int busId,
  ) async {

    final response =
        await ApiService.dio.get(
      "/driver/tracking/$busId",
    );

    if (response.data["success"] == true) {

      return DriverTrackingModel.fromJson(
        response.data["data"],
      );

    }

    return null;
  }

  Future<void> startTracking(
    int driverId,
  ) async {

    await ApiService.dio.post(
      "/location/start/$driverId",
    );

  }

  Future<void> stopTracking(
    int driverId,
  ) async {

    await ApiService.dio.post(
      "/location/stop/$driverId",
    );

  }

  Future<void> sendLocation({

    required int driverId,

    required double latitude,

    required double longitude,

    required double speed,

    required double heading,

    required double accuracy,

  }) async {

    await ApiService.dio.post(

      "/location/update",

      data: {

        "driver_id": driverId,

        "latitude": latitude,

        "longitude": longitude,

        "speed": speed,

        "heading": heading,

        "accuracy": accuracy,

      },

    );

  }

}