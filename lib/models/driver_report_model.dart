class DriverReportModel {
  final String driverName;

  final String kontak;

  final String status;

  final String companyName;

  DriverReportModel({
    required this.driverName,

    required this.kontak,

    required this.status,

    required this.companyName,
  });

  factory DriverReportModel.fromJson(Map<String, dynamic> json) {
    return DriverReportModel(
      driverName: json["driver_name"],

      kontak: json["kontak"],

      status: json["status"],

      companyName: json["company_name"] ?? "",
    );
  }
}
