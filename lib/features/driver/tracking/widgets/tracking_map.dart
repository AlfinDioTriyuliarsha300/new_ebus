import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../providers/driver_tracking_provider.dart';

class TrackingMap extends StatefulWidget {
  final DriverTrackingProvider provider;

  const TrackingMap({super.key, required this.provider});

  @override
  State<TrackingMap> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingMap> {
  final MapController _mapController = MapController();

  LatLng? _lastPosition;

  bool _isFirstLoad = true;

  void _fitRoute() {
    final tracking = widget.provider.trackingData;

    if (tracking == null) return;

    if (tracking.route == null) return;

    final points = <LatLng>[];

    points.addAll(tracking.route!.path.map((e) => LatLng(e.lat, e.lng)));

    points.add(
      LatLng(
        tracking.route!.terminalAwal.lat,

        tracking.route!.terminalAwal.lng,
      ),
    );

    points.add(
      LatLng(
        tracking.route!.terminalTujuan.lat,

        tracking.route!.terminalTujuan.lng,
      ),
    );

    for (final cp in tracking.route!.checkpoints) {
      points.add(LatLng(cp.lat, cp.lng));
    }

    if (points.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: points,

          padding: const EdgeInsets.all(70),
        ),
      );
    });
  }

  @override
  void didUpdateWidget(covariant TrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final tracking = widget.provider.trackingData;

    final bus = widget.provider.busLocation;

    if (tracking != null && _isFirstLoad) {
      _isFirstLoad = false;
      _fitRoute();
      return;
    }

    if (bus != null) {
      if (_lastPosition == null || _lastPosition != bus) {
        _lastPosition = bus;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(bus, _mapController.camera.zoom);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = widget.provider.trackingData;

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

                color: (tracking?.bus.status.toLowerCase() == "aktif")
                    ? Colors.green
                    : (tracking?.bus.status.toLowerCase() == "offline")
                    ? Colors.red
                    : Colors.orange,

                points: tracking!.route!.path
                    .map((e) => LatLng(e.lat, e.lng))
                    .toList(),
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
                  angle:
                      (widget.provider.currentPosition?.heading ?? 0) *
                      3.141592653589793 /
                      180,

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),

                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: .20),
                            shape: BoxShape.circle,
                          ),
                        ),

                        const Icon(
                          Icons.directions_bus,
                          color: Colors.blue,
                          size: 38,
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
