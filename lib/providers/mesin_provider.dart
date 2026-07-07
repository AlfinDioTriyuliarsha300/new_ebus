import 'package:flutter/material.dart';

import '../core/services/mesin_service.dart';
import '../models/mesin_model.dart';

class MesinProvider
    extends ChangeNotifier {

  final MesinService _service =
      MesinService();

  List<MesinModel> mesinList = [];

  Future<void> getMesin() async {

    mesinList =
        await _service.getMesin();

    notifyListeners();
  }
}