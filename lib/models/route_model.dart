import 'package:latlong2/latlong.dart';

class RouteModel {
  final int id;

  final int companyId;

  final String namaRute;

  final String titikAwal;

  final String titikTujuan;

  final List<dynamic> path;

  final double jarakEstimasi;

  final int startTerminalId;

  final int endTerminalId;

  final int? checkpointAId;

  final int? checkpointBId;

  final String routeMode;

  final double? startLat;
  final double? startLng;

  final double? endLat;
  final double? endLng;

  final double? checkpointALat;
  final double? checkpointALng;

  final double? checkpointBLat;
  final double? checkpointBLng;

  RouteModel({
    required this.id,
    required this.companyId,
    required this.namaRute,
    required this.titikAwal,
    required this.titikTujuan,
    required this.path,
    required this.jarakEstimasi,
    required this.startTerminalId,
    required this.endTerminalId,

    this.checkpointAId,
    this.checkpointBId,

    this.startLat,
    this.startLng,

    this.endLat,
    this.endLng,

    this.checkpointALat,
    this.checkpointALng,

    this.checkpointBLat,
    this.checkpointBLng,

    required this.routeMode,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json["id"] ?? 0,

      companyId: json["company_id"] ?? 0,

      namaRute: json["nama_rute"] ?? "",

      titikAwal: json["titik_awal"] ?? "",

      titikTujuan: json["titik_tujuan"] ?? "",

      path: json["path"] ?? [],

      jarakEstimasi: double.tryParse(json["jarak_estimasi"].toString()) ?? 0,

      startTerminalId: json["start_terminal_id"] ?? 0,

      endTerminalId: json["end_terminal_id"] ?? 0,

      checkpointAId: json["checkpoint_a_id"],

      checkpointBId: json["checkpoint_b_id"],

      routeMode: json["route_mode"] ?? "tol",

      startLat:
          double.tryParse(
            json["start_lat"]?.toString() ?? "",
          ),

      startLng:
          double.tryParse(
            json["start_lng"]?.toString() ?? "",
          ),

      endLat:
          double.tryParse(
            json["end_lat"]?.toString() ?? "",
          ),

      endLng:
          double.tryParse(
            json["end_lng"]?.toString() ?? "",
          ),

      checkpointALat:
          double.tryParse(
            json["checkpoint_a_lat"]?.toString() ?? "",
          ),

      checkpointALng:
          double.tryParse(
            json["checkpoint_a_lng"]?.toString() ?? "",
          ),

      checkpointBLat:
          double.tryParse(
            json["checkpoint_b_lat"]?.toString() ?? "",
          ),

      checkpointBLng:
          double.tryParse(
            json["checkpoint_b_lng"]?.toString() ?? "",
          ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,

      "company_id": companyId,

      "nama_rute": namaRute,

      "titik_awal": titikAwal,

      "titik_tujuan": titikTujuan,

      "path": path,

      "jarak_estimasi": jarakEstimasi,

      "start_terminal_id": startTerminalId,

      "end_terminal_id": endTerminalId,

      "checkpoint_a_id": checkpointAId,

      "checkpoint_b_id": checkpointBId,

      "route_mode": routeMode,
    };
  }

  List<LatLng> get points {
    if (path.isEmpty) return [];

    try {
      return path
          .where((e) =>
              e != null &&
              e["lat"] != null &&
              e["lng"] != null)
          .map<LatLng>((e) {
        return LatLng(
          double.parse(e["lat"].toString()),
          double.parse(e["lng"].toString()),
        );
      }).toList();
    } catch (e) {
      print("ERROR PARSE PATH : $e");
      return [];
    }
  }
}
