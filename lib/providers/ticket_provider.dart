import 'package:flutter/material.dart';
import 'package:new_ebus/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/ticket_service.dart';
import '../models/ticket_bus_model.dart';
import '../models/my_ticket_model.dart';

class TicketProvider extends ChangeNotifier {
  final TicketService _service = TicketService();

  bool loading = false;

  String? errorMessage;

  String? ticketNumber;

  TicketBusModel? selectedBus;

  MyTicketModel? ticket;

  List<MyTicketModel> tickets = [];

  List<TicketBusModel> listBus = [];

  /*
  ==========================
  LOAD BUS
  ==========================
  */

  Future<void> loadBus() async {
    loading = true;

    errorMessage = null;

    notifyListeners();

    try {
      listBus = await _service.getAvailableBuses();
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;

    notifyListeners();
  }

  /*
  ==========================
  BUY TICKET
  ==========================
  */
  Future<bool> buyTicket({
    required TicketBusModel bus,
    required String passengerName,
    required String phone,
  }) async {
    loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt(StorageKeys.userId);

      debugPrint("USER ID LOGIN = $userId");

      final ticket = await _service.buyTicket(
        scheduleId: bus.scheduleId,
        busId: bus.busId,
        passengerName: passengerName,
        phone: phone,
        userId: userId, // WAJIB
      );

      ticketNumber = ticket;
      selectedBus = bus;

      await saveTicket();

      await loadMyTicket(); // refresh tiket

      loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = e.toString();

      loading = false;

      notifyListeners();

      return false;
    }
  }

  /*
  ==========================
  SAVE
  ==========================
  */

  Future<void> saveTicket() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("ticket_number", ticketNumber ?? "");

    if (selectedBus != null) {
      await prefs.setInt("bus_id", selectedBus!.busId);

      await prefs.setInt("schedule_id", selectedBus!.scheduleId);

      await prefs.setString("bus_number", selectedBus!.nomorBus);

      await prefs.setString("company", selectedBus!.company);

      await prefs.setString("route", selectedBus!.route);
    }
  }

  /*
  ==========================
  CLEAR
  ==========================
  */

  Future<void> clearTicket() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("ticket_number");

    await prefs.remove("bus_id");

    await prefs.remove("schedule_id");

    await prefs.remove("bus_number");

    await prefs.remove("company");

    await prefs.remove("route");

    ticketNumber = null;

    selectedBus = null;

    notifyListeners();
  }

  /*
  ==========================
  load My Ticket
  ==========================
  */
  Future<void> loadMyTicket() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt(StorageKeys.userId);

      if (userId == null) {
        ticket = null;
        notifyListeners();
        return;
      }

      ticket = await _service.getMyTicket(userId);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /*
  ==========================
  load Tickets
  ==========================
  */
  Future<void> loadTickets(int userId) async {
    loading = true;
    notifyListeners();
    try {
      tickets = await _service.getMyTickets(userId);
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;

    notifyListeners();
  }
}
