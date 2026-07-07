import '../../models/user_model.dart';
import 'api_service.dart';

class ProfileService {

  Future<UserModel> getProfile(
      int userId) async {

    final response =
        await ApiService.dio.get(
      "/users/profile/$userId",
    );

    return UserModel.fromJson(
      response.data["data"],
    );
  }
}