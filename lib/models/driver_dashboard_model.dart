class DriverDashboardModel {
  final int driverId;
  final String driverName;
  final String driverStatus;

  final String companyName;

  final int? busId;
  final String nomorBus;
  final String platNomor;
  final String busStatus;
  final bool isTracking;

  final int? scheduleId;
  final String routeName;
  final String tanggal;
  final String jam;

  DriverDashboardModel({
    required this.driverId,
    required this.driverName,
    required this.driverStatus,
    required this.companyName,
    this.busId,
    required this.nomorBus,
    required this.platNomor,
    required this.busStatus,
    required this.isTracking,
    this.scheduleId,
    required this.routeName,
    required this.tanggal,
    required this.jam,
  });

  factory DriverDashboardModel.fromJson(
      Map<String, dynamic> json) {
    return DriverDashboardModel(
      driverId: json["driver_id"] ?? 0,
      driverName: json["driver_name"] ?? "",
      driverStatus: json["driver_status"] ?? "",

      companyName: json["company_name"] ?? "",

      busId: json["bus_id"],
      nomorBus: json["nomor_bus"] ?? "-",
      platNomor: json["plat_nomor"] ?? "-",
      busStatus: json["bus_status"] ?? "-",
      isTracking: json["is_tracking"] ?? false,

      scheduleId: json["schedule_id"],
      routeName: json["nama_rute"] ?? "-",
      tanggal: json["tanggal_berangkat"]?.toString() ?? "-",
      jam: json["jam_berangkat"]?.toString() ?? "-",
    );
  }
}