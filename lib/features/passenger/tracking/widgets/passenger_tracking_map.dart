import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../providers/passenger_tracking_provider.dart';

class PassengerTrackingMap extends StatefulWidget {
  final PassengerTrackingProvider provider;

  const PassengerTrackingMap({super.key, required this.provider});

  @override
  State<PassengerTrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<PassengerTrackingMap> {
  final MapController _mapController = MapController();

  LatLng? _lastPosition;
  LatLng? _animatedPosition;

  Timer? _animationTimer;

  @override
  void didUpdateWidget(covariant PassengerTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bus = widget.provider.busLocation;

    if (bus == null) return;

    // Pertama kali membuka halaman
    if (_lastPosition == null) {
      _lastPosition = bus;

      _animatedPosition = bus;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.provider.followBus) {
          _mapController.move(bus, 16);
        }
      });

      return;
    }

    // Update posisi bus tanpa menggeser kamera lagi
    if (_lastPosition!.latitude != bus.latitude ||
        _lastPosition!.longitude != bus.longitude) {
      _animateMarker(_lastPosition!, bus);

      _lastPosition = bus;
    }
  }

  void _animateMarker(LatLng from, LatLng to) {
    _animationTimer?.cancel();

    const totalStep = 20;

    int currentStep = 0;

    _animationTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      currentStep++;

      final t = currentStep / totalStep;

      final position = LatLng(
        from.latitude + ((to.latitude - from.latitude) * t),
        from.longitude + ((to.longitude - from.longitude) * t),
      );

      setState(() {
        _animatedPosition = position;
      });

      // Kamera mengikuti marker
      if (widget.provider.followBus) {
        _mapController.move(position, _mapController.camera.zoom);
      }

      if (currentStep >= totalStep) {
        timer.cancel();
      }
    });
  }

  void moveToBus() {
    final bus = widget.provider.busLocation;

    if (bus == null) return;

    _mapController.move(bus, _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final tracking = widget.provider.trackingData;

    Color busColor = Colors.blue;

    if (tracking != null) {
      switch (tracking.bus.status) {
        case "Siap Berangkat":
          busColor = Colors.green;
          break;

        case "Perjalanan":
          busColor = Colors.blue;
          break;

        case "Selesai":
          busColor = Colors.red;
          break;

        default:
          busColor = Colors.orange;
      }
    }

    final center =
        widget.provider.busLocation ?? const LatLng(-7.983908, 112.621391);

    final heading =
        (tracking?.location.heading ?? 0) * (3.141592653589793 / 180);

    return FlutterMap(
      mapController: _mapController,

      options: MapOptions(
        initialCenter: center,
        initialZoom: 16,

        onPositionChanged: (position, hasGesture) {
          if (hasGesture) {
            widget.provider.disableFollowBus();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

          userAgentPackageName: "com.new_ebus",
        ),

        //---------------------------------------
        // ROUTE
        //---------------------------------------
        if (tracking?.route != null)
          PolylineLayer(
            polylines: [
              Polyline(
                strokeWidth: 6,

                color: tracking!.bus.status == "Siap Berangkat"
                    ? Colors.green
                    : tracking.bus.status == "Perjalanan"
                    ? Colors.blue
                    : tracking.bus.status == "Selesai"
                    ? Colors.red
                    : Colors.orange,

                points: tracking.route!.path
                    .map((e) => LatLng(e.lat, e.lng))
                    .toList(),
              ),
            ],
          ),

        //---------------------------------------
        // GEOFENCE
        //---------------------------------------
        if (tracking?.route != null)
          CircleLayer(
            circles: [
              CircleMarker(
                point: LatLng(
                  tracking!.route!.terminalAwal.lat,
                  tracking.route!.terminalAwal.lng,
                ),
                radius: 200,
                useRadiusInMeter: true,
                color: Colors.green.withValues(alpha: .20),
                borderColor: Colors.green,
                borderStrokeWidth: 2,
              ),

              CircleMarker(
                point: LatLng(
                  tracking.route!.terminalTujuan.lat,
                  tracking.route!.terminalTujuan.lng,
                ),
                radius: 200,
                useRadiusInMeter: true,
                color: Colors.red.withValues(alpha: .20),
                borderColor: Colors.red,
                borderStrokeWidth: 2,
              ),

              ...tracking.route!.checkpoints.map(
                (cp) => CircleMarker(
                  point: LatLng(cp.lat, cp.lng),

                  radius: 200,

                  useRadiusInMeter: true,

                  color: Colors.orange.withValues(alpha: .15),

                  borderColor: Colors.orange,

                  borderStrokeWidth: 2,
                ),
              ),
            ],
          ),

        //---------------------------------------
        // TERMINAL + CHECKPOINT
        //---------------------------------------
        if (tracking?.route != null)
          MarkerLayer(
            markers: [
              // Terminal Awal
              Marker(
                point: LatLng(
                  tracking!.route!.terminalAwal.lat,
                  tracking.route!.terminalAwal.lng,
                ),
                width: 80,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flag_circle,
                      color: Colors.green,
                      size: 36,
                    ),
                    Text(
                      tracking.route!.terminalAwal.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Terminal Tujuan
              Marker(
                point: LatLng(
                  tracking.route!.terminalTujuan.lat,
                  tracking.route!.terminalTujuan.lng,
                ),
                width: 80,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flag_circle, color: Colors.red, size: 36),
                    Text(
                      tracking.route!.terminalTujuan.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Semua Checkpoint
              ...tracking.route!.checkpoints.map(
                (cp) => Marker(
                  point: LatLng(cp.lat, cp.lng),
                  width: 80,
                  height: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.orange,
                        size: 50,
                      ),
                      Text(
                        cp.nama,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        //---------------------------------------
        // BUS
        //---------------------------------------
        if (widget.provider.busLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _animatedPosition ?? widget.provider.busLocation!,
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: _showBusInfo,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 5),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              tracking?.bus.nomorBus ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),

                            Text(
                              "${tracking?.location.speed.toStringAsFixed(0) ?? "0"} km/j",
                              style: TextStyle(color: busColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 2),

                      Transform.rotate(
                        angle: heading,
                        child: Icon(
                          Icons.directions_bus,
                          color: busColor,
                          size: 55,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _showBusInfo() {
    final tracking = widget.provider.trackingData;

    if (tracking == null) return;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.directions_bus, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tracking.bus.nomorBus,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("Perusahaan", tracking.company),

              _infoRow("Plat Nomor", tracking.bus.platNomor),

              _infoRow("Status", tracking.bus.status),

              _infoRow(
                "Kecepatan",
                "${tracking.location.speed.toStringAsFixed(1)} km/jam",
              ),

              _infoRow(
                "Progress",
                "${tracking.location.progress.toStringAsFixed(0)} %",
              ),

              _infoRow("Zona", tracking.location.currentZone ?? "-"),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Text(": "),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();

    super.dispose();
  }
}
