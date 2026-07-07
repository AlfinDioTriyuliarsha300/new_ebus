class ScheduleModel {
  final int id;
  final int busId;
  final int routeId;
  final String tanggalBerangkat;
  final String jamBerangkat;
  final String hargaTiket;
  final String status;
  final String? platNomor;
  final String? namaRute;

  ScheduleModel({
    required this.id,
    required this.busId,
    required this.routeId,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.hargaTiket,
    required this.status,
    this.platNomor,
    this.namaRute,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],

      busId: json['bus_id'],

      routeId: json['route_id'],

      tanggalBerangkat: json['tanggal_berangkat'] ?? '',

      jamBerangkat: json['jam_berangkat'] ?? '',

      hargaTiket: json['harga_tiket'].toString(),

      status: json['status'] ?? '',

      platNomor: json['plat_nomor'],

      namaRute: json['nama_rute'],
    );
  }
}
