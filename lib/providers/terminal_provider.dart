import 'package:flutter/material.dart';

import '../core/services/terminal_service.dart';

import '../models/terminal_model.dart';

class TerminalProvider extends ChangeNotifier {
  final TerminalService _service = TerminalService();

  List<TerminalModel> terminals = [];

  bool isLoading = false;

  Future<void> loadTerminals() async {
    try {
      isLoading = true;

      notifyListeners();

      terminals = await _service.getTerminals();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> createTerminal({
    required int cityId,
    required String namaTerminal,
    required String alamat,
    required double lat,
    required double lng,
  }) async {
    await _service.createTerminal(
      cityId: cityId,
      namaTerminal: namaTerminal,
      alamat: alamat,
      lat: lat,
      lng: lng,
    );

    await loadTerminals();
  }

  Future<void> updateTerminal({
    required int id,
    required int cityId,
    required String namaTerminal,
    required String alamat,
    required double lat,
    required double lng,
  }) async {
    await _service.updateTerminal(
      id: id,
      cityId: cityId,
      namaTerminal: namaTerminal,
      alamat: alamat,
      lat: lat,
      lng: lng,
    );

    await loadTerminals();
  }

  Future<void> deleteTerminal(int id) async {
    await _service.deleteTerminal(id);

    await loadTerminals();
  }
}
