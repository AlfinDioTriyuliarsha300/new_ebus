import '../../models/passenger_home_model.dart';
import 'api_service.dart';

class PassengerHomeService {
  Future<List<PassengerSchedule>> getSchedules() async {
    final response = await ApiService.dio.get("/passenger/home");

    return (response.data["data"] as List)
        .map((e) => PassengerSchedule.fromJson(e))
        .toList();
  }

  Future<List<PassengerTicket>> getTickets(int userId) async {
    final response = await ApiService.dio.get(
      "/passenger/home/tickets/$userId",
    );

    return (response.data["data"] as List)
        .map((e) => PassengerTicket.fromJson(e))
        .toList();
  }

  Future<Map<String, dynamic>> buyTicket({
    required int userId,

    required int scheduleId,

    required String passengerName,

    required String phone,
  }) async {
    final response = await ApiService.dio.post(
      "/passenger/home/buy-ticket",

      data: {
        "user_id": userId,

        "schedule_id": scheduleId,

        "passenger_name": passengerName,

        "phone": phone,
      },
    );

    return response.data["data"];
  }
}
