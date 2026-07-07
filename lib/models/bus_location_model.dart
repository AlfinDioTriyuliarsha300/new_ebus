class BusLocationModel {
  final int id;
  final String platNomor;
  final double latitude;
  final double longitude;
  final bool isTracking;

  BusLocationModel({
    required this.id,
    required this.platNomor,
    required this.latitude,
    required this.longitude,
    required this.isTracking,
  });

  factory BusLocationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusLocationModel(
      id: json["id"],

      platNomor:
          json["plat_nomor"] ?? "",

      latitude:
          double.tryParse(
                json["latitude"].toString(),
              ) ??
              0,

      longitude:
          double.tryParse(
                json["longitude"].toString(),
              ) ??
              0,

      isTracking:
          json["is_tracking"] ?? false,
    );
  }
}