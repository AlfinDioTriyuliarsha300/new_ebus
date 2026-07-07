class CheckpointModel {
  final int id;
  final String nama;
  final String tipe;
  final double lat;
  final double lng;

  CheckpointModel({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.lat,
    required this.lng,
  });

  factory CheckpointModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CheckpointModel(
      id: json["id"],
      nama: json["nama"] ?? "",
      tipe: json["tipe"] ?? "",
      lat: double.parse(json["lat"].toString()),
      lng: double.parse(json["lng"].toString()),
    );
  }
}