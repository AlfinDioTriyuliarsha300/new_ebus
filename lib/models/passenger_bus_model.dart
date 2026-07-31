class PassengerBusModel {
  final int busId;

  final String nomorBus;

  final String platNomor;

  final String status;

  final String company;

  final int scheduleId;

  final DateTime tanggalBerangkat;

  final String jamBerangkat;

  final double hargaTiket;

  final String route;

  PassengerBusModel({
    required this.busId,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.company,
    required this.scheduleId,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.hargaTiket,
    required this.route,
  });

  factory PassengerBusModel.fromJson(Map<String, dynamic> json) {
    return PassengerBusModel(
      busId: json["bus_id"],

      nomorBus: json["nomor_bus"],

      platNomor: json["plat_nomor"],

      status: json["status"],

      company: json["company"],

      scheduleId: json["schedule_id"],

      tanggalBerangkat: DateTime.parse(json["tanggal_berangkat"]),

      jamBerangkat: json["jam_berangkat"],

      hargaTiket: double.parse(json["harga_tiket"].toString()),

      route: json["route"],
    );
  }

  String get tanggalFormat {
    return "${tanggalBerangkat.day.toString().padLeft(2, '0')}-"
        "${tanggalBerangkat.month.toString().padLeft(2, '0')}-"
        "${tanggalBerangkat.year}";
  }

  String get hargaFormat {
    return "Rp ${hargaTiket.toStringAsFixed(0)}";
  }
}
