import '../../models/driver_dashboard_model.dart';
import 'api_service.dart';

class DriverDashboardService {
  Future<DriverDashboardModel> getDashboard(int userId) async {
    print("USER ID = $userId");

    final response = await ApiService.dio.get("/driver/dashboard/$userId");

    return DriverDashboardModel.fromJson(response.data["data"]);
  }
}
