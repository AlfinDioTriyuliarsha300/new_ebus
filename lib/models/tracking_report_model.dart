class TrackingReportModel {
  final String nomorBus;

  final double? latitude;

  final double? longitude;

  final bool tracking;

  final String status;

  TrackingReportModel({
    required this.nomorBus,

    required this.latitude,

    required this.longitude,

    required this.tracking,

    required this.status,
  });

  factory TrackingReportModel.fromJson(Map<String, dynamic> json) {
    return TrackingReportModel(
      nomorBus: json["nomor_bus"],

      latitude: json["latitude"],

      longitude: json["longitude"],

      tracking: json["is_tracking"] ?? false,

      status: json["status"],
    );
  }
}
