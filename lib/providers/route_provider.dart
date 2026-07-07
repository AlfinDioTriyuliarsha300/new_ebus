import 'package:flutter/material.dart';
import 'package:new_ebus/models/terminal_model.dart';

import '../models/route_model.dart';
import '../core/services/route_service.dart';

class RouteProvider extends ChangeNotifier {
  final RouteService _service = RouteService();

  List<RouteModel> routes = [];

  bool isLoading = false;

  

  Future<void> getRoutes(int companyId) async {
    try {
      isLoading = true;

      notifyListeners();

      routes =
          await _service.getRoutes(companyId);

      print(
        "TOTAL ROUTE : ${routes.length}",
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> deleteRoute(int id, int companyId) async {
    await _service.deleteRoute(id);
    await getRoutes(companyId);
  }

  Future<void> createRoute({
    required int companyId,
    required String namaRute,
    required TerminalModel startTerminal,
    required TerminalModel endTerminal,
    int? checkpointAId,
    int? checkpointBId,
    String routeMode = "tol",
  }) async {
    await _service.createRoute(
      companyId: companyId,
      namaRute: namaRute,
      startTerminal: startTerminal,
      endTerminal: endTerminal,
      checkpointAId: checkpointAId,
      checkpointBId: checkpointBId,
      routeMode: routeMode,
    );

    await getRoutes(companyId);
  }

  Future<void> updateRoute({
    required int id,
    required int companyId,
    required String namaRute,
    required TerminalModel startTerminal,
    required TerminalModel endTerminal,
    int? checkpointAId,
    int? checkpointBId,
    String routeMode = "tol",
  }) async {

    await _service.updateRoute(
      id: id,
      companyId: companyId,
      namaRute: namaRute,
      startTerminal: startTerminal,
      endTerminal: endTerminal,
      checkpointAId: checkpointAId,
      checkpointBId: checkpointBId,
      routeMode: routeMode,
    );

    await getRoutes(companyId);
  }
}
