class ProvinceModel {
  final int id;
  final String namaProvinsi;

  ProvinceModel({
    required this.id,
    required this.namaProvinsi,
  });

  factory ProvinceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProvinceModel(
      id: json["id"],
      namaProvinsi: json["nama_provinsi"],
    );
  }
}