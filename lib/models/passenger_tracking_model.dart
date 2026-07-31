class PassengerTrackingModel {
  final PassengerData passenger;
  final TicketData ticket;
  final BusData bus;
  final String company;
  final LocationData location;
  final RouteData? route;

  PassengerTrackingModel({
    required this.passenger,
    required this.ticket,
    required this.bus,
    required this.company,
    required this.location,
    this.route,
  });

  factory PassengerTrackingModel.fromJson(Map<String, dynamic> json) {
    return PassengerTrackingModel(
      passenger: PassengerData.fromJson(json["passenger"]),
      ticket: TicketData.fromJson(json["ticket"]),
      bus: BusData.fromJson(json["bus"]),
      company: json["company"],
      location: LocationData.fromJson(json["location"]),
      route: json["route"] == null ? null : RouteData.fromJson(json["route"]),
    );
  }
}

class PassengerData {
  final String nama;
  final String phone;
  final int userId;

  PassengerData({
    required this.nama,
    required this.phone,
    required this.userId,
  });

  factory PassengerData.fromJson(Map<String, dynamic> json) {
    return PassengerData(
      nama: json["nama"],
      phone: json["phone"],
      userId: json["user_id"],
    );
  }
}

class TicketData {
  final String nomor;

  TicketData({required this.nomor});

  factory TicketData.fromJson(Map<String, dynamic> json) {
    return TicketData(nomor: json["nomor"]);
  }
}

class BusData {
  final int id;

  final String nomorBus;

  final String platNomor;

  String status;

  final bool tracking;

  final String? currentZone;

  final String? currentZoneStatus;

  double progress;

  BusData({
    required this.id,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.tracking,
    this.currentZone,
    this.currentZoneStatus,
    required this.progress,
  });

  factory BusData.fromJson(Map<String, dynamic> json) {
    return BusData(
      id: json["id"],
      nomorBus: json["nomor_bus"],
      platNomor: json["plat_nomor"],
      status: json["status"],
      tracking: json["tracking"],
      currentZone: json["current_zone"],
      currentZoneStatus: json["current_zone_status"],
      progress: (json["progress"] ?? 0).toDouble(),
    );
  }
}

class LocationData {
  double lat;

  double lng;

  double speed;

  double heading;

  double accuracy;

  String? updatedAt;

  String? currentZone;

  String? currentZoneStatus;

  double progress;

  LocationData({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.heading,
    required this.accuracy,
    this.updatedAt,
    this.currentZone,
    this.currentZoneStatus,
    required this.progress,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      lat: double.tryParse(json["lat"].toString()) ?? 0,
      lng: double.tryParse(json["lng"].toString()) ?? 0,
      speed: double.tryParse(json["speed"].toString()) ?? 0,
      heading: double.tryParse(json["heading"].toString()) ?? 0,
      accuracy: double.tryParse(json["accuracy"].toString()) ?? 0,
      updatedAt: json["updated_at"]?.toString(),
      currentZone: json["current_zone"],
      currentZoneStatus: json["current_zone_status"],
      progress: double.tryParse(json["progress"].toString()) ?? 0,
    );
  }

  void updateFromSocket(Map<String, dynamic> json) {
    lat = double.tryParse((json["latitude"] ?? lat).toString()) ?? lat;
    lng = double.tryParse((json["longitude"] ?? lng).toString()) ?? lng;
    speed = double.tryParse((json["speed"] ?? speed).toString()) ?? speed;
    heading =
        double.tryParse((json["heading"] ?? heading).toString()) ?? heading;
    accuracy =
        double.tryParse((json["accuracy"] ?? accuracy).toString()) ?? accuracy;
    progress =
        double.tryParse((json["progress"] ?? progress).toString()) ?? progress;

    currentZone = json["current_zone"] ?? currentZone;

    currentZoneStatus = json["current_zone_status"] ?? currentZoneStatus;

    updatedAt = json["updated_at"]?.toString() ?? updatedAt;
  }
}

class RouteData {
  final int id;

  final String nama;

  final List<RoutePoint> path;

  final Terminal terminalAwal;

  final Terminal terminalTujuan;

  final List<Checkpoint> checkpoints;

  RouteData({
    required this.id,
    required this.nama,
    required this.path,
    required this.terminalAwal,
    required this.terminalTujuan,
    required this.checkpoints,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      id: json["id"],
      nama: json["nama"],
      path: (json["path"] as List).map((e) => RoutePoint.fromJson(e)).toList(),
      terminalAwal: Terminal.fromJson(json["terminal_awal"]),
      terminalTujuan: Terminal.fromJson(json["terminal_tujuan"]),
      checkpoints: (json["checkpoints"] as List)
          .map((e) => Checkpoint.fromJson(e))
          .toList(),
    );
  }
}

class RoutePoint {
  final double lat;
  final double lng;

  RoutePoint({required this.lat, required this.lng});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}

class Terminal {
  final String nama;

  final double lat;

  final double lng;

  Terminal({required this.nama, required this.lat, required this.lng});

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      nama: json["nama"],
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}

class Checkpoint {
  final int id;

  final String nama;

  final double lat;

  final double lng;

  Checkpoint({
    required this.id,
    required this.nama,
    required this.lat,
    required this.lng,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json["id"],
      nama: json["nama"],
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}
