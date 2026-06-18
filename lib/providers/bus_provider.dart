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
    required String nomorBus,
    required String platNomor,
    required String status,
  }) async {
    await _service.createBus(
      companyId: companyId,
      nomorBus: nomorBus,
      platNomor: platNomor,
      status: status,
    );

    await getBuses();
  }

  Future<void> editBus({
    required int id,
    required String nomorBus,
    required String platNomor,
    required String status,
  }) async {
    await _service.updateBus(
      id: id,
      nomorBus: nomorBus,
      platNomor: platNomor,
      status: status,
    );

    await getBuses();
  }

  Future<void> removeBus(int id) async {
    await _service.deleteBus(id);

    await getBuses();
  }
}
