import 'package:new_ebus/core/services/api_service.dart';

import '../../models/schedule_model.dart';

class ScheduleService {
  Future<List<ScheduleModel>>
  getSchedules(
    int companyId,
  ) async {

    final response =
        await ApiService.dio.get(
          "/schedules/company/$companyId",
        );

    print(response.data);

    final List data =
        response.data["data"];

    return data
        .map(
          (e)=>ScheduleModel.fromJson(e)
        )
        .toList();
  }

  Future<void> createSchedule({
    required int companyId,
    required int busId,
    required int routeId,
    required String tanggal,
    required String jam,
    required String harga,
  }) async {

    await ApiService.dio.post(
      "/schedules",

      data: {
        "company_id": companyId,
        "bus_id": busId,
        "route_id": routeId,
        "tanggal_berangkat": tanggal,
        "jam_berangkat": jam,
        "harga_tiket": harga,
      },
    );
  }

  Future<void> updateSchedule({
    required int id,
    required String tanggal,
    required String jam,
    required String harga,
  }) async {

    await ApiService.dio.put(
      "/schedules/$id",

      data: {
        "tanggal_berangkat": tanggal,
        "jam_berangkat": jam,
        "harga_tiket": harga,
      },
    );
  }

  Future<void> deleteSchedule(int id) async {
    await ApiService.dio.delete(
      "/schedules/$id",
    );
  }
}