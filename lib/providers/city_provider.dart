import 'package:flutter/material.dart';

import '../core/services/city_service.dart';
import '../models/city_model.dart';

class CityProvider extends ChangeNotifier {

  final CityService _service =
      CityService();

  List<CityModel> startCities = [];

  List<CityModel> endCities = [];

  bool isLoadingStart = false;

  bool isLoadingEnd = false;

  Future<void> loadStartCities(
    int provinceId,
  ) async {

    try {

      isLoadingStart = true;

      notifyListeners();

      startCities =
          await _service
              .getCitiesByProvince(
        provinceId,
      );

    } finally {

      isLoadingStart = false;

      notifyListeners();
    }
  }

  Future<void> loadEndCities(
    int provinceId,
  ) async {

    try {

      isLoadingEnd = true;

      notifyListeners();

      endCities =
          await _service
              .getCitiesByProvince(
        provinceId,
      );

    } finally {

      isLoadingEnd = false;

      notifyListeners();
    }
  }

  void clearStartCities() {

    startCities.clear();

    notifyListeners();
  }

  void clearEndCities() {

    endCities.clear();

    notifyListeners();
  }
}