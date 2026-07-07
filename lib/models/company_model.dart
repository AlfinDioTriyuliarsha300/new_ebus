class CompanyModel {

  final int id;
  final String companyName;
  final String alamat;
  final String email;
  final String telepon;
  final String website;
  final String status;

  CompanyModel({
    required this.id,
    required this.companyName,
    required this.alamat,
    required this.email,
    required this.telepon,
    required this.website,
    required this.status,
  });

  factory CompanyModel.fromJson(
      Map<String, dynamic> json) {

    return CompanyModel(

      id: json["id"] ?? 0,

      companyName:
          json["nama_perusahaan"] ??
          json["company_name"] ??
          "",

      alamat:
          json["alamat"] ?? "",

      email:
          json["email"] ?? "",

      telepon:
          json["phone"] ??
          json["telepon"] ??
          "",

      website:
          json["website"] ?? "",

      status:
          json["status"] ?? "",
    );
  }
}