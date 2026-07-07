import 'package:dio/dio.dart';

import 'api_service.dart';
import '../../models/bus_model.dart';

class BusService {
  Future<List<BusModel>> getAllBuses() async {
    Response response = await ApiService.dio.get("/buses");

    if (response.data["success"]) {
      List data = response.data["data"];

      return data.map((e) => BusModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil data bus");
  }

  Future<void> createBus({
  required int companyId,
  required int? driverId,
  required String nomorBus,
  required String platNomor,
  required int mesinId,
  required int? routeId,
  required int? scheduleId,
  required String status,
}) async {

  await ApiService.dio.post(
    "/buses",
    data: {
      "company_id": companyId,
      "driver_id": driverId,
      "nomor_bus": nomorBus,
      "plat_nomor": platNomor,
      "mesin_id": mesinId,
      "route_id": routeId,
      "schedule_id": scheduleId,
      "status": status,
    },
  );
}

  Future<void> updateBus({
    required int id,
    required int companyId,
    required int? driverId,
    required String nomorBus,
    required String platNomor,
    required int mesinId,
    required int? routeId,
    required int? scheduleId,
    required String status,
  }) async {
    await ApiService.dio.put(
      "/buses/$id",
      data: {
        "company_id": companyId,
        "driver_id": driverId,
        "nomor_bus": nomorBus,
        "plat_nomor": platNomor,
        "mesin_id": mesinId,
        "route_id": routeId,
        "schedule_id": scheduleId,
        "status": status,
      },
    );
  }

  Future<void> deleteBus(int id) async {
    await ApiService.dio.delete("/buses/$id");
  }
}
