import 'package:new_ebus/core/services/api_service.dart';

import '../../models/driver_model.dart';

class DriverService {
  Future<List<DriverModel>> getDrivers(int companyId) async {
    final response = await ApiService.dio.get("/drivers/company/$companyId");

    List data = response.data["data"];

    return data.map((e) => DriverModel.fromJson(e)).toList();
  }

  Future<void> createDriver({
    required int companyId,
    required String nama,
    required String kontak,
  }) async {
    await ApiService.dio.post(
      "/drivers",

      data: {"company_id": companyId, "driver_name": nama, "kontak": kontak},
    );
  }

  Future<void> updateDriver({
    required int id,
    required String nama,
    required String kontak,
    required String status,
  }) async {
    await ApiService.dio.put(
      "/drivers/$id",

      data: {"driver_name": nama, "kontak": kontak, "status": status},
    );
  }

  Future<void> deleteDriver(int id) async {
    await ApiService.dio.delete("/drivers/$id");
  }
}
