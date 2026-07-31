class PassengerSchedule {
  final int scheduleId;
  final int busId;

  final String nomorBus;
  final String platNomor;

  final String companyName;

  final String routeName;

  final String departure;

  final String arrival;

  final String status;

  PassengerSchedule({
    required this.scheduleId,
    required this.busId,
    required this.nomorBus,
    required this.platNomor,
    required this.companyName,
    required this.routeName,
    required this.departure,
    required this.arrival,
    required this.status,
  });

  factory PassengerSchedule.fromJson(Map<String, dynamic> json) {
    return PassengerSchedule(
      scheduleId: json["schedule_id"],
      busId: json["bus_id"],
      nomorBus: json["nomor_bus"],
      platNomor: json["plat_nomor"],
      companyName: json["company_name"],
      routeName: json["nama_rute"],
      departure: json["jam_berangkat"].toString(),
      arrival: json["jam_tiba"].toString(),
      status: json["status"],
    );
  }
}

class PassengerTicket {
  final int id;

  final int busId;

  final int scheduleId;

  final String ticketNumber;

  final String passengerName;

  final String nomorBus;

  final String routeName;

  final String status;

  PassengerTicket({
    required this.id,

    required this.busId,

    required this.scheduleId,

    required this.ticketNumber,

    required this.passengerName,

    required this.nomorBus,

    required this.routeName,

    required this.status,
  });

  factory PassengerTicket.fromJson(Map<String, dynamic> json) {
    return PassengerTicket(
      id: json["id"],

      busId: json["bus_id"],

      scheduleId: json["schedule_id"],

      ticketNumber: json["ticket_number"],

      passengerName: json["passenger_name"],

      nomorBus: json["nomor_bus"],

      routeName: json["nama_rute"],

      status: json["status"],
    );
  }
}
