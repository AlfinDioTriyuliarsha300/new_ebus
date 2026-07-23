import 'package:flutter/material.dart';

import '../core/services/ticket_service.dart';
import '../models/ticket_model.dart';

class TicketProvider extends ChangeNotifier{

  final TicketService _service =
      TicketService();

  List<TicketModel> tickets=[];

  bool loading=false;

  Future<void> loadTickets(
      int userId,
  ) async{

    loading=true;

    notifyListeners();

    try{

      tickets=
          await _service.getUserTickets(
              userId,
          );

    }catch(e){

      debugPrint(e.toString());

    }

    loading=false;

    notifyListeners();

  }

}