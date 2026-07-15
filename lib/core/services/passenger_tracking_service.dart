import 'package:dio/dio.dart';

import '../../models/passenger_tracking_model.dart';
import 'api_service.dart';

class PassengerTrackingService {
  Future<PassengerTrackingModel> getTracking(String ticket) async {
    final Response response = await ApiService.dio.get(
      "/passenger/tracking/$ticket",
    );

    return PassengerTrackingModel.fromJson(response.data["data"]);
  }
}
