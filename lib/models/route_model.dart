class RouteModel {
  final int id;
  final String namaRute;
  final String titikAwal;
  final String titikTujuan;

  RouteModel({
    required this.id,
    required this.namaRute,
    required this.titikAwal,
    required this.titikTujuan,
  });

  factory RouteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RouteModel(
      id: json['id'],
      namaRute: json['nama_rute'] ?? '',
      titikAwal: json['titik_awal'] ?? '',
      titikTujuan: json['titik_tujuan'] ?? '',
    );
  }
}