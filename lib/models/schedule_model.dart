class ScheduleModel {
  final int id;
  final int busId;
  final int routeId;
  final String tanggalBerangkat;
  final String jamBerangkat;
  final String hargaTiket;

  ScheduleModel({
    required this.id,
    required this.busId,
    required this.routeId,
    required this.tanggalBerangkat,
    required this.jamBerangkat,
    required this.hargaTiket,
  });

  factory ScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScheduleModel(
      id: json['id'],
      busId: json['bus_id'],
      routeId: json['route_id'],
      tanggalBerangkat:
          json['tanggal_berangkat'] ?? '',
      jamBerangkat:
          json['jam_berangkat'] ?? '',
      hargaTiket:
          json['harga_tiket'].toString(),
    );
  }
}