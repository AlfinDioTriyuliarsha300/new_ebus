class CompanyReportModel {
  final int id;

  final String companyName;

  final String status;

  final int totalDriver;

  final int totalBus;

  final int totalRoute;

  final int totalSchedule;

  CompanyReportModel({
    required this.id,

    required this.companyName,

    required this.status,

    required this.totalDriver,

    required this.totalBus,

    required this.totalRoute,

    required this.totalSchedule,
  });

  factory CompanyReportModel.fromJson(Map<String, dynamic> json) {
    return CompanyReportModel(
      id: json["id"],

      companyName: json["company_name"],

      status: json["status"],

      totalDriver: int.parse(json["total_driver"].toString()),

      totalBus: int.parse(json["total_bus"].toString()),

      totalRoute: int.parse(json["total_route"].toString()),

      totalSchedule: int.parse(json["total_schedule"].toString()),
    );
  }
}
