class TicketBusModel {
  final int busId;
  final String nomorBus;
  final String platNomor;
  final String company;
  final String route;
  final int scheduleId;
  final DateTime tanggalBerangkat;
  final String jamBerangkat;
  final double hargaTiket;
  final String status;

  TicketBusModel({
    required this.busId,
    required this.nomorBus,
    required this.platNomor,
    required this.company,
    required this.route,
    required this.scheduleId,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.hargaTiket,
    required this.status,
  });

  factory TicketBusModel.fromJson(Map<String, dynamic> json) {
    return TicketBusModel(
      busId: json["bus_id"],
      nomorBus: json["nomor_bus"],
      platNomor: json["plat_nomor"],
      company: json["company"],
      route: json["route"],
      scheduleId: json["schedule_id"],
      tanggalBerangkat: DateTime.parse(json["tanggal_berangkat"]),
      jamBerangkat: json["jam_berangkat"],
      hargaTiket: double.parse(json["harga_tiket"].toString()),
      status: json["status"],
    );
  }

  // Tambahkan ini
  String get tanggalFormatted {
    return "${tanggalBerangkat.day.toString().padLeft(2, '0')}-"
        "${tanggalBerangkat.month.toString().padLeft(2, '0')}-"
        "${tanggalBerangkat.year}";
  }

  // Tambahkan ini juga agar harga lebih rapi
  String get hargaFormatted {
    return "Rp ${hargaTiket.toStringAsFixed(0)}";
  }
}