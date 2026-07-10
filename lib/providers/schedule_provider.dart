import 'package:flutter/material.dart';

import '../core/services/schedule_service.dart';

import '../models/schedule_model.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleService _service = ScheduleService();

  List<ScheduleModel> schedules = [];

  bool isLoading = false;

  Future<void> getSchedules(int companyId) async {
    print("LOAD SCHEDULE COMPANY = $companyId");

    isLoading = true;

    notifyListeners();

    schedules = await _service.getSchedules(companyId);

    print("TOTAL SCHEDULE = ${schedules.length}");

    isLoading = false;

    notifyListeners();
  }

  Future<void> createSchedule({
    required int companyId,
    required int busId,
    required int routeId,
    required String tanggal,
    required String jam,
    required String harga,
  }) async {
    await _service.createSchedule(
      companyId: companyId,
      busId: busId,
      routeId: routeId,
      tanggal: tanggal,
      jam: jam,
      harga: harga,
    );

    await getSchedules(companyId);
  }

  Future<void> updateSchedule({
    required int id,
    required int companyId,
    required int busId,
    required int routeId,
    required String tanggal,
    required String jam,
    required String harga,

  }) async {

    await _service.updateSchedule(
      id: id,
      busId: busId,
      routeId: routeId,
      tanggal: tanggal,
      jam: jam,
      harga: harga,
    );

    await getSchedules(companyId);
  }

  Future<void> deleteSchedule(int id, int companyId) async {
    await _service.deleteSchedule(id);

    await getSchedules(companyId);
  }
}
