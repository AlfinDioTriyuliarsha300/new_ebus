class DriverTrackingModel {
  final BusTracking bus;
  final DriverTracking driver;
  final String company;
  final RouteTracking? route;
  final LocationTracking location;

  DriverTrackingModel({
    required this.bus,
    required this.driver,
    required this.company,
    required this.route,
    required this.location,
  });

  factory DriverTrackingModel.fromJson(Map<String, dynamic> json) {
    return DriverTrackingModel(
      bus: BusTracking.fromJson(json["bus"]),

      driver: DriverTracking.fromJson(json["driver"]),

      company: json["company"] ?? "",

      route: json["route"] == null
          ? null
          : RouteTracking.fromJson(json["route"]),

      location: LocationTracking.fromJson(json["location"]),
    );
  }
}

/////////////////////////////////////////////////////

class BusTracking {
  final int id;
  final String nomorBus;
  final String platNomor;
  final String status;
  final bool tracking;

  // ==========================
  // TAMBAHAN
  // ==========================
  final String currentZone;
  final String currentZoneStatus;
  final int routeIndex;
  final double progress;

  BusTracking({
    required this.id,
    required this.nomorBus,
    required this.platNomor,
    required this.status,
    required this.tracking,
    required this.currentZone,
    required this.currentZoneStatus,
    required this.routeIndex,
    required this.progress,
  });

  factory BusTracking.fromJson(Map<String, dynamic> json) {
    return BusTracking(
      id: json["id"] ?? 0,
      nomorBus: json["nomor_bus"] ?? "",
      platNomor: json["plat_nomor"] ?? "",
      status: json["status"] ?? "",
      tracking: json["tracking"] ?? false,
      currentZone: json["current_zone"] ?? "",
      currentZoneStatus: json["current_zone_status"] ?? "",
      routeIndex: json["route_index"] ?? 0,
      progress: double.tryParse(json["progress"].toString()) ?? 0,
    );
  }
}

/////////////////////////////////////////////////////

class DriverTracking {
  final int id;
  final String nama;

  DriverTracking({required this.id, required this.nama});

  factory DriverTracking.fromJson(Map<String, dynamic> json) {
    return DriverTracking(id: json["id"] ?? 0, nama: json["nama"] ?? "");
  }
}

/////////////////////////////////////////////////////

class LocationTracking {
  final double lat;
  final double lng;
  final double speed;
  final double heading;
  final double accuracy;
  final double progress;

  final String updatedAt;
  final String currentZone;
  final String currentZoneStatus;

  final int routeIndex;

  LocationTracking({
    required this.lat,
    required this.lng,

    required this.speed,
    required this.heading,
    required this.accuracy,

    required this.updatedAt,

    required this.currentZone,
    required this.currentZoneStatus,

    required this.progress,
    required this.routeIndex,
  });

  factory LocationTracking.fromJson(
    Map<String,dynamic> json){

    return LocationTracking(

      lat:
        double.tryParse(
          json["lat"].toString(),
        ) ?? 0,

      lng:
        double.tryParse(
          json["lng"].toString(),
        ) ?? 0,

      speed:
        double.tryParse(
          json["speed"].toString(),
        ) ?? 0,

      heading:
        double.tryParse(
          json["heading"].toString(),
        ) ?? 0,

      accuracy:
        double.tryParse(
          json["accuracy"].toString(),
        ) ?? 0,

      updatedAt:
        json["updated_at"]?.toString() ?? "",

      currentZone:
        json["current_zone"] ?? "-",

      currentZoneStatus:
        json["current_zone_status"] ?? "-",

      progress:
        double.tryParse(
          json["progress"].toString(),
        ) ?? 0,

      routeIndex:
        json["route_index"] ?? 0,
    );
  }
}

/////////////////////////////////////////////////////

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

  factory RouteTracking.fromJson(Map<String, dynamic> json) {
    return RouteTracking(
      id: json["id"] ?? 0,

      nama: json["nama"] ?? "",

      path: (json["path"] as List<dynamic>? ?? [])
          .map((e) => RoutePoint.fromJson(e))
          .toList(),

      terminalAwal: TerminalAwal.fromJson(json["terminal_awal"]),

      terminalTujuan: TerminalTujuan.fromJson(json["terminal_tujuan"]),

      checkpoints: (json["checkpoints"] as List<dynamic>? ?? [])
          .map((e) => CheckpointTracking.fromJson(e))
          .toList(),
    );
  }
}

/////////////////////////////////////////////////////

class RoutePoint {
  final double lat;
  final double lng;

  RoutePoint({required this.lat, required this.lng});

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      lat: double.tryParse(json["lat"].toString()) ?? 0.0,

      lng: double.tryParse(json["lng"].toString()) ?? 0.0,
    );
  }
}

/////////////////////////////////////////////////////

class TerminalAwal {
  final String nama;
  final double lat;
  final double lng;

  TerminalAwal({required this.nama, required this.lat, required this.lng});

  factory TerminalAwal.fromJson(Map<String, dynamic> json) {
    return TerminalAwal(
      nama: json["nama"] ?? "",

      lat: double.tryParse(json["lat"].toString()) ?? 0.0,

      lng: double.tryParse(json["lng"].toString()) ?? 0.0,
    );
  }
}

/////////////////////////////////////////////////////

class TerminalTujuan {
  final String nama;
  final double lat;
  final double lng;

  TerminalTujuan({required this.nama, required this.lat, required this.lng});

  factory TerminalTujuan.fromJson(Map<String, dynamic> json) {
    return TerminalTujuan(
      nama: json["nama"] ?? "",

      lat: double.tryParse(json["lat"].toString()) ?? 0.0,

      lng: double.tryParse(json["lng"].toString()) ?? 0.0,
    );
  }
}

/////////////////////////////////////////////////////

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

  factory CheckpointTracking.fromJson(Map<String, dynamic> json) {
    return CheckpointTracking(
      id: json["id"] ?? 0,

      nama: json["nama"] ?? "",

      lat: double.tryParse(json["lat"].toString()) ?? 0.0,

      lng: double.tryParse(json["lng"].toString()) ?? 0.0,
    );
  }
}
