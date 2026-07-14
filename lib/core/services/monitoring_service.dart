import '../../models/bus_location_model.dart';
import 'api_service.dart';
import 'package:flutter/material.dart';

class MonitoringService {
  Future<List<BusLocationModel>> getLocations(int companyId) async {
    final response = await ApiService.dio.get("/buses/company/$companyId");

    debugPrint(response.data);

    final List data = response.data["data"];

    debugPrint("TOTAL BUS API = ${data.length}");

    return data
        .where((e) {
          debugPrint(e);

          return e["latitude"] != null &&
              e["longitude"] != null &&
              e["is_tracking"] == true;
        })
        .map((e) => BusLocationModel.fromJson(e))
        .toList();
  }
}
