class MyTicketModel {
  final String ticketNumber;

  final String passengerName;

  final String phone;

  final String seatNumber;

  final String status;

  final int busId;

  final int scheduleId;

  final String nomorBus;

  final String platNomor;

  final String tanggalBerangkat;

  final String jamBerangkat;

  final String hargaTiket;

  MyTicketModel({
    required this.ticketNumber,
    required this.passengerName,
    required this.phone,
    required this.seatNumber,
    required this.status,
    required this.busId,
    required this.scheduleId,
    required this.nomorBus,
    required this.platNomor,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.hargaTiket,
  });

  factory MyTicketModel.fromJson(Map<String, dynamic> json) {
    return MyTicketModel(
      ticketNumber: json["ticket_number"] ?? "",

      passengerName: json["passenger_name"] ?? "",

      phone: json["phone"] ?? "",

      seatNumber: json["seat_number"] ?? "",

      status: json["status"] ?? "",

      busId: json["bus_id"] ?? 0,

      scheduleId: json["schedule_id"] ?? 0,

      nomorBus: json["nomor_bus"] ?? "",

      platNomor: json["plat_nomor"] ?? "",

      tanggalBerangkat:
          json["tanggal_berangkat"]?.toString() ?? "",

      jamBerangkat:
          json["jam_berangkat"]?.toString() ?? "",

      hargaTiket:
          json["harga_tiket"]?.toString() ?? "",
    );
  }
}