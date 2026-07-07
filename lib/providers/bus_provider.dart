import 'package:flutter/material.dart';

import '../core/services/bus_service.dart';

import '../models/bus_model.dart';

class BusProvider extends ChangeNotifier {
  final BusService _service = BusService();

  bool isLoading = false;

  List<BusModel> buses = [];

  Future<void> getBuses() async {
    try {
      isLoading = true;

      notifyListeners();

      buses = await _service.getAllBuses();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> addBus({
    required int companyId,
    required int? driverId,
    required String nomorBus,
    required String platNomor,
    required int mesinId,
    required int? routeId,
    required int? scheduleId,
    required String status,
  }) async {
    await _service.createBus(
      companyId: companyId,
      driverId: driverId,
      nomorBus: nomorBus,
      platNomor: platNomor,
      mesinId: mesinId,
      routeId: routeId,
      scheduleId: scheduleId,
      status: status,
    );

    await getBuses();
  }

  Future<void> editBus({
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
    await _service.updateBus(
      id: id,
      companyId: companyId,
      driverId: driverId,
      nomorBus: nomorBus,
      platNomor: platNomor,
      mesinId: mesinId,
      routeId: routeId,
      scheduleId: scheduleId,
      status: status,
    );

    await getBuses();
  }

  Future<void> removeBus(int id) async {
    await _service.deleteBus(id);

    await getBuses();
  }
}
