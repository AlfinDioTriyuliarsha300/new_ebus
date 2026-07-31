import 'package:dio/dio.dart';

import '../../models/ticket_bus_model.dart';
import '../../models/my_ticket_model.dart';
import 'api_service.dart';

class TicketService {
  Future<List<TicketBusModel>> getAvailableBuses() async {
    final Response response = await ApiService.dio.get("/tickets/buses");

    if (response.data["success"] != true) {
      throw Exception("Gagal mengambil daftar bus");
    }

    final List list = response.data["data"];

    return list.map((e) => TicketBusModel.fromJson(e)).toList();
  }

  Future<String> buyTicket({
    required String passengerName,
    required String phone,
    required int busId,
    required int scheduleId,
    required int? userId,
  }) async {
    final Response response = await ApiService.dio.post(
      "/tickets/buy",
      data: {
        "passenger_name": passengerName,
        "phone": phone,
        "bus_id": busId,
        "schedule_id": scheduleId,
        "user_id": userId,
      },
    );

    if (response.data["success"] != true) {
      throw Exception(response.data["message"]);
    }

    return response.data["data"]["ticket_number"];
  }

  Future<MyTicketModel?> getMyTicket(int userId) async {
    final response = await ApiService.dio.get("/tickets/my/$userId");

    if (response.data["data"] == null) {
      return null;
    }

    return MyTicketModel.fromJson(response.data["data"]);
  }

  Future<List<MyTicketModel>> getMyTickets(int userId) async {

    final response =
        await ApiService.dio.get("/tickets/my-list/$userId");

    if (response.data["success"] != true) {
      throw Exception("Gagal mengambil tiket");
    }

    final List list = response.data["data"];

    return list
        .map((e) => MyTicketModel.fromJson(e))
        .toList();
  }
}
