import 'package:flutter/material.dart';

import '../core/services/ticket_service.dart';
import '../models/ticket_model.dart';

class TicketProvider extends ChangeNotifier {
  final TicketService service = TicketService();

  bool loading = false;

  List<TicketModel> tickets = [];

  Future<void> loadTickets() async {
    loading = true;

    notifyListeners();

    try {
      tickets = await service.getTickets();
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;

    notifyListeners();
  }
}
