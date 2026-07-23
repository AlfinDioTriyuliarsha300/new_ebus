import 'package:dio/dio.dart';
import 'package:new_ebus/core/services/api_service.dart';

import '../../models/ticket_model.dart';

class TicketService {
  Future<List<TicketModel>> getUserTickets(int userId) async {
    final Response response = await ApiService.dio.get("/tickets/user/$userId");

    return (response.data["data"] as List)
        .map((e) => TicketModel.fromJson(e))
        .toList();
  }
}
