class BusReportModel{

  final String nomorBus;

  final String platNomor;

  final String status;

  final bool tracking;

  final String driverName;

  final String companyName;

  BusReportModel({

    required this.nomorBus,

    required this.platNomor,

    required this.status,

    required this.tracking,

    required this.driverName,

    required this.companyName,
  });

  factory BusReportModel.fromJson(
      Map<String,dynamic> json){

    return BusReportModel(

      nomorBus:
          json["nomor_bus"],

      platNomor:
          json["plat_nomor"],

      status:
          json["status"],

      tracking:
          json["is_tracking"] ?? false,

      driverName:
          json["driver_name"] ?? "-",

      companyName:
          json["company_name"] ?? "",
    );
  }

}