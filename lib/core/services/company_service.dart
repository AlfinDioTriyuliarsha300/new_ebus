import '../../models/company_model.dart';
import 'api_service.dart';

class CompanyService {
  Future<CompanyModel> getCompany(int companyId) async {
    final response = await ApiService.dio.get("/companies/$companyId");

    return CompanyModel.fromJson(response.data["data"]);
  }

  Future<void> updateCompany({
    required int companyId,

    required String namaPerusahaan,
    required String alamat,
    required String email,
    required String phone,
    required String website,
  }) async {
    await ApiService.dio.put(
      "/companies/$companyId",

      data: {
        "company_name": namaPerusahaan,
        "alamat": alamat,
        "email": email,
        "telepon": phone,
        "website": website,
      },
    );
  }

  Future<void> changePassword({
    required int companyId,

    required String oldPassword,

    required String newPassword,
  }) async {
    await ApiService.dio.put(
      "/companies/change-password/$companyId",

      data: {"oldPassword": oldPassword, "newPassword": newPassword},
    );
  }

  Future<List<CompanyModel>> getCompanies() async {
    final response = await ApiService.dio.get("/companies");

    final List data = response.data["data"];

    return data.map((e) => CompanyModel.fromJson(e)).toList();
  }

  Future<void> createCompany({
    required String namaPerusahaan,
    required String alamat,
    required String email,
    required String phone,
    required String website,
  }) async {
    await ApiService.dio.post(
      "/companies",

      data: {
        "company_name": namaPerusahaan,
        "alamat": alamat,
        "email": email,
        "telepon": phone,
        "website": website,
      },
    );
  }

  Future<void> deleteCompany(int companyId) async {
    await ApiService.dio.delete("/companies/$companyId");
  }

  Future<void> resetPassword(int companyId) async {
    await ApiService.dio.put("/companies/reset-password/$companyId");
  }
}
