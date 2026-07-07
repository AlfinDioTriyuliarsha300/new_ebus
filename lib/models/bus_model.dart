class BusModel {
  final int id;
  final int companyId;
  final String nomorBus;
  final String platNomor;
  final String status;
  final bool isTracking;
  final int? driverId;
  final int? mesinId;
  final int? routeId;
  final int? scheduleId;

  BusModel({
    required this.id,
    required this.companyId,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.isTracking,
    required this.driverId,
    required this.mesinId,
    required this.routeId,
    required this.scheduleId,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json["id"] ?? 0,
      companyId: json["company_id"] ?? 0,
      nomorBus: json["nomor_bus"] ?? "",
      platNomor: json["plat_nomor"] ?? "",
      status: json["status"] ?? "",
      isTracking: json["is_tracking"] ?? false,
      driverId: json["driver_id"],
      mesinId: json["mesin_id"],
      routeId: json["route_id"],
      scheduleId: json["schedule_id"],
    );
  }
}
