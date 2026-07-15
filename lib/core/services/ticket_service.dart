import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ticket_model.dart';
import 'api_service.dart';

class TicketService {
  Future<List<TicketModel>> getTickets() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("user_id");

    if (userId == null) {
      return [];
    }

    final response = await ApiService.dio.get("/tickets/user/$userId");

    final List data = response.data["data"];

    return data.map((e) => TicketModel.fromJson(e)).toList();
  }
}
