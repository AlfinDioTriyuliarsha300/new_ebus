import 'package:dio/dio.dart';
import 'package:new_ebus/models/terminal_model.dart';

import '../../models/route_model.dart';
import 'api_service.dart';

class RouteService {

  // ===============================
  // GET ROUTES
  // ===============================
  Future<List<RouteModel>> getRoutes(
      int companyId) async {

    final response =
        await ApiService.dio.get(
      '/routes/company/$companyId',
    );

    final List data =
        response.data["data"];

    return data
        .map(
          (e) => RouteModel.fromJson(e),
        )
        .toList();
  }


  // ===============================
  // DELETE ROUTE
  // ===============================
  Future<void> deleteRoute(
      int id) async {

    await ApiService.dio.delete(
      '/routes/$id',
    );
  }


  // ===============================
  // CREATE ROUTE
  // ===============================
  Future<void> createRoute({
    required int companyId,
    required String namaRute,
    required TerminalModel startTerminal,
    required TerminalModel endTerminal,
    int? checkpointAId,
    int? checkpointBId,
    String routeMode = "tol",
  }) async {

    final body = {
      "company_id": companyId,
      "nama_rute": namaRute,

      "start_terminal_id":
          startTerminal.id,

      "end_terminal_id":
          endTerminal.id,

      "checkpoint_a_id":
          checkpointAId,

      "checkpoint_b_id":
          checkpointBId,

      "route_mode": routeMode,
    };

    print("SEND DATA:");
    print(body);

    await ApiService.dio.post(
      "/routes",
      data: body,
    );
  }


  // ===============================
  // UPDATE ROUTE
  // ===============================
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

    await ApiService.dio.put(

      "/routes/$id",

      data: {

        "company_id":
            companyId,

        "nama_rute":
            namaRute,

        "titik_awal": {
          "lat": startTerminal.lat,
          "lng": startTerminal.lng,
        },

        "titik_tujuan": {
          "lat": endTerminal.lat,
          "lng": endTerminal.lng,
        },

        "jarak_estimasi": "0",

        "path": [],

        "route_mode":
            routeMode,

        "start_terminal_id":
            startTerminal.id,

        "end_terminal_id":
            endTerminal.id,

        "checkpoint_a_id":
            checkpointAId,

        "checkpoint_b_id":
            checkpointBId,
      },
    );
  }


  // ===============================
  // GET ROUTE BUS
  // ===============================
  Future<RouteModel?> getRouteBus(
      int busId) async {

    try {

      final response =
          await ApiService.dio.get(
        '/routes/bus/$busId',
      );

      if (response.data["data"] == null) {
        return null;
      }

      return RouteModel.fromJson(
        response.data["data"],
      );

    } catch (e) {

      print(e);

      return null;
    }
  }
}