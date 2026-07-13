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

  Future<void> startTracking(int driverId) async {
    try {
      final response = await ApiService.dio.post(
        "/driver/tracking/start",
        data: {
          "driver_id": driverId,
        },
      );

      print(response.data);
    } on DioException catch (e) {
      print("STATUS = ${e.response?.statusCode}");
      print("DATA = ${e.response?.data}");
      rethrow;
    }
  }

  Future<void> stopTracking(
    int driverId,
  ) async {

    await ApiService.dio.post(

      "/driver/tracking/stop",

      data: {
        "driver_id": driverId,
      },

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

    "/driver/tracking/update-location",

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