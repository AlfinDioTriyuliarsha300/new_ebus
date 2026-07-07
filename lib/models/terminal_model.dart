class TerminalModel {

  final int id;

  final int cityId;

  final String namaTerminal;

  final String alamat;

  final double lat;

  final double lng;

  TerminalModel({
    required this.id,
    required this.cityId,
    required this.namaTerminal,
    required this.alamat,
    required this.lat,
    required this.lng,
  });

  factory TerminalModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TerminalModel(
      id: json["id"],

      cityId:
          json["city_id"] ?? 0,

      namaTerminal:
          json["nama_terminal"] ?? "",

      alamat:
          json["alamat"] ?? "",

      lat:
          double.parse(
            json["lat"].toString(),
          ),

      lng:
          double.parse(
            json["lng"].toString(),
          ),
    );
  }
}