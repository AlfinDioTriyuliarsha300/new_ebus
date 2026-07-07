class CityModel {
  final int id;
  final int provinceId;
  final String namaKota;
  final String tipe;

  CityModel({
    required this.id,
    required this.provinceId,
    required this.namaKota,
    required this.tipe,
  });

  factory CityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CityModel(
      id: json["id"],
      provinceId: json["province_id"],
      namaKota: json["nama_kota"],
      tipe: json["tipe"],
    );
  }
}