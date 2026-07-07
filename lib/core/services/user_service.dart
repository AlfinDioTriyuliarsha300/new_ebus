import '../../models/user_model.dart';
import 'api_service.dart';

class UserService {
  Future<List<UserModel>> getUsers() async {
    final response = await ApiService.dio.get("/users");

    final List data = response.data["data"];

    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> resetPassword(int userId, String password) async {
    await ApiService.dio.put(
      "/users/reset-password/$userId",

      data: {"newPassword": password},
    );
  }

  Future<void> createUser({
    required String email,

    required String password,

    required String role,

    required int companyId,
  }) async {
    await ApiService.dio.post(
      "/users",

      data: {
        "email": email,

        "password": password,

        "role": role,

        "company_id": companyId,
      },
    );
  }

  Future<void> updateUser({
    required int id,
    required String email,
    required String role,
    required int companyId,
  }) async {
    await ApiService.dio.put(
      "/users/$id",

      data: {"email": email, "role": role, "company_id": companyId},
    );
  }

  Future<void> deleteUser(int id) async {
    await ApiService.dio.delete("/users/$id");
  }
}
