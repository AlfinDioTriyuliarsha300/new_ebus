import 'bus_report_model.dart';
import 'company_report_model.dart';
import 'driver_report_model.dart';
import 'report_summary_model.dart';
import 'role_chart_model.dart';
import 'schedule_report_model.dart';
import 'tracking_report_model.dart';

class SuperAdminReportModel {
  final ReportSummaryModel summary;

  final List<RoleChartModel> roles;

  final List<CompanyReportModel> companies;

  final List<DriverReportModel> drivers;

  final List<BusReportModel> buses;

  final List<ScheduleReportModel> schedules;

  final List<TrackingReportModel> tracking;

  SuperAdminReportModel({
    required this.summary,

    required this.roles,

    required this.companies,

    required this.drivers,

    required this.buses,

    required this.schedules,

    required this.tracking,
  });

  factory SuperAdminReportModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminReportModel(
      summary: ReportSummaryModel.fromJson(json["summary"]),

      roles: (json["roles"] as List)
          .map((e) => RoleChartModel.fromJson(e))
          .toList(),

      companies: (json["companies"] as List)
          .map((e) => CompanyReportModel.fromJson(e))
          .toList(),

      drivers: (json["drivers"] as List)
          .map((e) => DriverReportModel.fromJson(e))
          .toList(),

      buses: (json["buses"] as List)
          .map((e) => BusReportModel.fromJson(e))
          .toList(),

      schedules: (json["schedules"] as List)
          .map((e) => ScheduleReportModel.fromJson(e))
          .toList(),

      tracking: (json["tracking"] as List)
          .map((e) => TrackingReportModel.fromJson(e))
          .toList(),
    );
  }
}
