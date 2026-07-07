import 'package:flutter/material.dart';
import '../core/services/province_service.dart';
import '../models/province_model.dart';

class ProvinceProvider extends ChangeNotifier {
  final ProvinceService _service = ProvinceService();

  List<ProvinceModel> provinces = [];

  bool isLoading = false;

  Future<void> loadProvinces() async {
    try {
      isLoading = true;

      notifyListeners();

      provinces = await _service.getProvinces();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
