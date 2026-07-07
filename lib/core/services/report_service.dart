import 'api_service.dart';

class ReportService {
  Future<Map<String, dynamic>> loadDashboard() async {
    final response = await ApiService.dio.get("/reports/super-admin");

    return response.data;
  }
}
