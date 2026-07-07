import 'package:flutter/material.dart';

import '../core/services/driver_service.dart';
import '../models/driver_model.dart';

class DriverProvider extends ChangeNotifier {
  final DriverService _service = DriverService();

  bool isLoading = false;

  List<DriverModel> drivers = [];

  Future<void> getDrivers(int companyId) async {
    isLoading = true;
    notifyListeners();
    drivers = await _service.getDrivers(companyId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> createDriver({
    required int companyId,
    required String nama,
    required String kontak,
  }) async {
    await _service.createDriver(
      companyId: companyId,
      nama: nama,
      kontak: kontak,
    );
    await getDrivers(companyId);
  }

  Future<void> updateDriver({
    required int id,
    required int companyId,
    required String nama,
    required String kontak,
    required String status,
  }) async {
    await _service.updateDriver(
      id: id,
      nama: nama,
      kontak: kontak,
      status: status,
    );
    await getDrivers(companyId);
  }

  Future<void> deleteDriver(int id, int companyId) async {
    await _service.deleteDriver(id);
    await getDrivers(companyId);
  }
}
