class RoleChartModel {
  final String role;
  final int total;

  RoleChartModel({required this.role, required this.total});

  factory RoleChartModel.fromJson(Map<String, dynamic> json) {
    return RoleChartModel(role: json["role"], total: json["total"]);
  }
}
