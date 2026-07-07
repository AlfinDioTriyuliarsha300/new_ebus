class DriverTrackingModel {
  final BusTracking bus;
  final DriverTracking driver;
  final String company;
  final RouteTracking route;
  final LocationTracking location;

  DriverTrackingModel({
    required this.bus,
    required this.driver,
    required this.company,
    required this.route,
    required this.location,
  });

  factory DriverTrackingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverTrackingModel(
      bus: BusTracking.fromJson(json["bus"]),
      driver: DriverTracking.fromJson(json["driver"]),
      company: json["company"] ?? "",
      route: RouteTracking.fromJson(json["route"]),
      location: LocationTracking.fromJson(json["location"]),
    );
  }
}

class BusTracking {
  final int id;
  final String nomorBus;
  final String platNomor;
  final String status;
  final bool tracking;

  BusTracking({
    required this.id,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.tracking,
  });

  factory BusTracking.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusTracking(
      id: json["id"],
      nomorBus: json["nomor_bus"] ?? "",
      platNomor: json["plat_nomor"] ?? "",
      status: json["status"] ?? "",
      tracking: json["tracking"] ?? false,
    );
  }
}

class DriverTracking {
  final int id;
  final String nama;

  DriverTracking({
    required this.id,
    required this.nama,
  });

  factory DriverTracking.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverTracking(
      id: json["id"],
      nama: json["nama"] ?? "",
    );
  }
}

class LocationTracking {
  final double lat;
  final double lng;
  final double speed;
  final double heading;
  final double accuracy;
  final DateTime? updatedAt;

  LocationTracking({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.heading,
    required this.accuracy,
    this.updatedAt,
  });

  factory LocationTracking.fromJson(
    Map<String, dynamic> json,
  ) {
    return LocationTracking(
      lat: (json["lat"] ?? 0).toDouble(),
      lng: (json["lng"] ?? 0).toDouble(),
      speed: (json["speed"] ?? 0).toDouble(),
      heading: (json["heading"] ?? 0).toDouble(),
      accuracy: (json["accuracy"] ?? 0).toDouble(),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }
}

class RouteTracking {
  final int id;
  final String nama;
  final List<RoutePoint> path;
  final TerminalAwal terminalAwal;
  final TerminalTujuan terminalTujuan;
  final List<CheckpointTracking> checkpoints;

  RouteTracking({
    required this.id,
    required this.nama,
    required this.path,
    required this.terminalAwal,
    required this.terminalTujuan,
    required this.checkpoints,
  });

  factory RouteTracking.fromJson(
    Map<String, dynamic> json,
  ) {
    return RouteTracking(
      id: json["id"],
      nama: json["nama"] ?? "",
      path: (json["path"] as List)
          .map((e) => RoutePoint.fromJson(e))
          .toList(),
      terminalAwal:
          TerminalAwal.fromJson(json["terminal_awal"]),
      terminalTujuan:
          TerminalTujuan.fromJson(json["terminal_tujuan"]),
      checkpoints:
          (json["checkpoints"] as List)
              .map((e) => CheckpointTracking.fromJson(e))
              .toList(),
    );
  }
}

class RoutePoint {
  final double lat;
  final double lng;

  RoutePoint({
    required this.lat,
    required this.lng,
  });

  factory RoutePoint.fromJson(
    Map<String, dynamic> json,
  ) {
    return RoutePoint(
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}

class TerminalAwal {
  final String nama;
  final double lat;
  final double lng;

  TerminalAwal({
    required this.nama,
    required this.lat,
    required this.lng,
  });

  factory TerminalAwal.fromJson(
    Map<String, dynamic> json,
  ) {
    return TerminalAwal(
      nama: json["nama"] ?? "",
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}

class TerminalTujuan {
  final String nama;
  final double lat;
  final double lng;

  TerminalTujuan({
    required this.nama,
    required this.lat,
    required this.lng,
  });

  factory TerminalTujuan.fromJson(
    Map<String, dynamic> json,
  ) {
    return TerminalTujuan(
      nama: json["nama"] ?? "",
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}

class CheckpointTracking {
  final int id;
  final String nama;
  final double lat;
  final double lng;

  CheckpointTracking({
    required this.id,
    required this.nama,
    required this.lat,
    required this.lng,
  });

  factory CheckpointTracking.fromJson(
    Map<String, dynamic> json,
  ) {
    return CheckpointTracking(
      id: json["id"],
      nama: json["nama"] ?? "",
      lat: (json["lat"]).toDouble(),
      lng: (json["lng"]).toDouble(),
    );
  }
}