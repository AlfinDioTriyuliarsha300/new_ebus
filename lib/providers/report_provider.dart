import 'package:flutter/material.dart';
import '../core/services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _service = ReportService();

  bool isLoading = false;

  Map<String, dynamic> summary = {};

  List<dynamic> roleStatistic = [];
  List<dynamic> companyStatistic = [];

  // Data tabel
  List<dynamic> drivers = [];
  List<dynamic> buses = [];
  List<dynamic> schedules = [];

  Future<void> loadDashboard() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _service.loadDashboard();

      summary = data["summary"] ?? {};

      roleStatistic = data["roles"] ?? [];

      companyStatistic = data["companies"] ?? [];

      drivers = data["drivers"] ?? [];

      buses = data["buses"] ?? [];

      schedules = data["schedules"] ?? [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int get totalUsers => summary["totalUsers"] ?? 0;

  int get totalCompanies => summary["totalCompanies"] ?? 0;

  int get totalDrivers => summary["totalDrivers"] ?? 0;

  int get totalBuses => summary["totalBuses"] ?? 0;

  int get totalSchedules => summary["totalSchedules"] ?? 0;
}