import 'package:flutter/material.dart';

import '../core/services/company_service.dart';
import '../models/company_model.dart';

class CompanyProvider extends ChangeNotifier {
  final CompanyService _service = CompanyService();

  CompanyModel? company;
  bool isLoading = false;
  List<CompanyModel> companies = [];

  Future<void> getCompany(int companyId) async {
    try {
      isLoading = true;
      notifyListeners();

      company = await _service.getCompany(companyId);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCompany({
    required int companyId,
    required String namaPerusahaan,
    required String alamat,
    required String email,
    required String phone,
    required String website,
  }) async {

    await _service.updateCompany(
      companyId: companyId,
      namaPerusahaan: namaPerusahaan,
      alamat: alamat,
      email: email,
      phone: phone,
      website: website,
    );

    // Refresh seluruh list
    await getCompanies();

    notifyListeners();
  }

  Future<void> changePassword({
    required int companyId,

    required String oldPassword,

    required String newPassword,
  }) async {
    await _service.changePassword(
      companyId: companyId,

      oldPassword: oldPassword,

      newPassword: newPassword,
    );
  }

  Future<void> getCompanies() async {
    try {
      isLoading = true;
      notifyListeners();

      companies = await _service.getCompanies();

      print("TOTAL COMPANY: ${companies.length}");
      print(companies);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCompany({
    required String namaPerusahaan,
    required String alamat,
    required String email,
    required String phone,
    required String website,
  }) async {

    await _service.createCompany(
      namaPerusahaan: namaPerusahaan,
      alamat: alamat,
      email: email,
      phone: phone,
      website: website,
    );

    await getCompanies();

    notifyListeners();
  }

  Future<void> deleteCompany(int companyId) async {
    await _service.deleteCompany(companyId);

    await getCompanies();
  }

  Future<void> resetPassword(int companyId) async {
    await _service.resetPassword(companyId);
  }
}
