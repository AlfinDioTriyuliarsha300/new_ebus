class BusModel {
  final int id;
  final int companyId;
  final String nomorBus;
  final String platNomor;
  final String status;

  BusModel({
    required this.id,
    required this.companyId,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
  });

  factory BusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusModel(
      id: json['id'],
      companyId: json['company_id'],
      nomorBus: json['nomor_bus'] ?? '',
      platNomor: json['plat_nomor'] ?? '',
      status: json['status'] ?? '',
    );
  }
}