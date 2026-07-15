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

  bool _isFirstLoad = true;

  @override
  void didUpdateWidget(covariant PassengerTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tracking = widget.provider.trackingData;

    final bus = widget.provider.busLocation;

    if (tracking != null && tracking.route != null && _isFirstLoad) {
      if (bus != null) {
        if (_lastPosition == null ||
            _lastPosition!.latitude != bus.latitude ||
            _lastPosition!.longitude != bus.longitude) {
          _lastPosition = bus;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(bus, _mapController.camera.zoom);
          });
        }
      }
    }
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
                point: widget.provider.busLocation!,

                width: 65,

                height: 65,

                child: Transform.rotate(
                  angle: 0,

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
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

                            style: const TextStyle(
                              fontSize: 10,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.directions_bus,
                                color: busColor,
                                size: 36,
                              ),

                              Positioned(
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
}
