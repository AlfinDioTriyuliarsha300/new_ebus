class TicketModel {
  final int id;

  final String ticketNumber;

  final String passengerName;

  final String phone;

  final String seatNumber;

  final String status;

  final int busId;

  final int scheduleId;

  final String nomorBus;

  final String platNomor;

  TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.passengerName,
    required this.phone,
    required this.seatNumber,
    required this.status,
    required this.busId,
    required this.scheduleId,
    required this.nomorBus,
    required this.platNomor,
  });

  factory TicketModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TicketModel(
      id: json["id"],

      ticketNumber: json["ticket_number"] ?? "",

      passengerName: json["passenger_name"] ?? "",

      phone: json["phone"] ?? "",

      seatNumber: json["seat_number"] ?? "",

      status: json["status"] ?? "",

      busId: json["bus_id"],

      scheduleId: json["schedule_id"],

      nomorBus: json["nomor_bus"] ?? "",

      platNomor: json["plat_nomor"] ?? "",
    );
  }
}