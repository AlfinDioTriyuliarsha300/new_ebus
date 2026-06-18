class BusModel {
  final int id;

  final int companyId;

  final String nomorBus;

  final String platNomor;

  final String status;

  final bool isTracking;

  BusModel({
    required this.id,
    required this.companyId,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.isTracking,
  });

  factory BusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusModel(
      id: json["id"] ?? 0,

      companyId:
          json["company_id"] ?? 0,

      nomorBus:
          json["nomor_bus"] ?? "",

      platNomor:
          json["plat_nomor"] ?? "",

      status:
          json["status"] ?? "",

      isTracking:
          json["is_tracking"] ?? false,
    );
  }
}