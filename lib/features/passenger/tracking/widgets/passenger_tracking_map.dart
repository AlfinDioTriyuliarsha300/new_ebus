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
        _mapController.move(bus, 16);
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

      setState(() {
        _animatedPosition = LatLng(
          from.latitude + ((to.latitude - from.latitude) * t),

          from.longitude + ((to.longitude - from.longitude) * t),
        );
      });

      if (currentStep >= totalStep) {
        timer.cancel();
      }
    });
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

      options: MapOptions(initialCenter: center, initialZoom: 16),

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
        // START TERMINAL
        //---------------------------------------
        if (tracking?.route != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  tracking!.route!.terminalAwal.lat,

                  tracking.route!.terminalAwal.lng,
                ),

                width: 50,

                height: 50,

                child: const Icon(Icons.flag, color: Colors.green, size: 40),
              ),
            ],
          ),

        //---------------------------------------
        // END TERMINAL
        //---------------------------------------
        if (tracking?.route != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  tracking!.route!.terminalTujuan.lat,

                  tracking.route!.terminalTujuan.lng,
                ),

                width: 50,

                height: 50,

                child: const Icon(
                  Icons.flag_circle,

                  color: Colors.red,

                  size: 40,
                ),
              ),
            ],
          ),

        //---------------------------------------
        // CHECKPOINT
        //---------------------------------------
        if (tracking?.route != null)
          MarkerLayer(
            markers: tracking!.route!.checkpoints
                .map(
                  (e) => Marker(
                    point: LatLng(e.lat, e.lng),

                    width: 35,

                    height: 35,

                    child: const Icon(Icons.location_on, color: Colors.orange),
                  ),
                )
                .toList(),
          ),

        //---------------------------------------
        // BUS
        //---------------------------------------
        if (widget.provider.busLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _animatedPosition ?? widget.provider.busLocation!,
                width: 65,
                height: 65,
                child: Transform.rotate(
                  angle: heading,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tracking?.bus.status ?? "-",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: busColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.directions_bus_filled,
                                color: busColor,
                                size: 38,
                              ),
                              const Positioned(
                                top: 2,
                                child: Icon(
                                  Icons.navigation,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();

    super.dispose();
  }
}
