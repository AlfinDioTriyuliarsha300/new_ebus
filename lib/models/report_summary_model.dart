class ReportSummaryModel {
  final int totalUsers;
  final int totalCompanies;
  final int totalDrivers;
  final int totalBuses;
  final int totalRoutes;
  final int totalSchedules;

  ReportSummaryModel({
    required this.totalUsers,
    required this.totalCompanies,
    required this.totalDrivers,
    required this.totalBuses,
    required this.totalRoutes,
    required this.totalSchedules,
  });

  factory ReportSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReportSummaryModel(
      totalUsers: json["totalUsers"] ?? 0,

      totalCompanies: json["totalCompanies"] ?? 0,

      totalDrivers: json["totalDrivers"] ?? 0,

      totalBuses: json["totalBuses"] ?? 0,

      totalRoutes: json["totalRoutes"] ?? 0,

      totalSchedules: json["totalSchedules"] ?? 0,
    );
  }
}
