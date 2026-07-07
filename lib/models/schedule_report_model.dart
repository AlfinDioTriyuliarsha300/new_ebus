class ScheduleReportModel {
  final String tanggal;

  final String jam;

  final double harga;

  final String status;

  final String bus;

  final String company;

  ScheduleReportModel({
    required this.tanggal,

    required this.jam,

    required this.harga,

    required this.status,

    required this.bus,

    required this.company,
  });

  factory ScheduleReportModel.fromJson(Map<String, dynamic> json) {
    return ScheduleReportModel(
      tanggal: json["tanggal_berangkat"],

      jam: json["jam_berangkat"],

      harga: double.parse(json["harga_tiket"].toString()),

      status: json["status"],

      bus: json["nomor_bus"] ?? "",

      company: json["company_name"] ?? "",
    );
  }
}
