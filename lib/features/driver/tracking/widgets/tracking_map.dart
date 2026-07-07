import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../providers/driver_tracking_provider.dart';

class TrackingMap extends StatelessWidget {
  final DriverTrackingProvider provider;

  const TrackingMap({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final tracking = provider.trackingData;

    if (tracking == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final busLocation = provider.busLocation ??
        LatLng(
          tracking.location.lat,
          tracking.location.lng,
        );

    final List<LatLng> routePath =
        tracking.route.path
            .map(
              (e) => LatLng(
                e.lat,
                e.lng,
              ),
            )
            .toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: busLocation,
        initialZoom: 15,
      ),

      children: [

        TileLayer(
          urlTemplate:
              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.new_ebus.app",
        ),

        PolylineLayer(
          polylines: [

            Polyline(
              points: routePath,

              strokeWidth: 6,

              color: Colors.blue,
            ),

          ],
        ),

        MarkerLayer(
          markers: [

            //-------------------------------
            // Terminal Awal
            //-------------------------------

            Marker(
              point: LatLng(
                tracking.route.terminalAwal.lat,
                tracking.route.terminalAwal.lng,
              ),

              width: 55,
              height: 55,

              child: const Icon(
                Icons.flag,
                color: Colors.green,
                size: 38,
              ),
            ),

            //-------------------------------
            // Terminal Tujuan
            //-------------------------------

            Marker(
              point: LatLng(
                tracking.route.terminalTujuan.lat,
                tracking.route.terminalTujuan.lng,
              ),

              width: 55,
              height: 55,

              child: const Icon(
                Icons.outlined_flag,
                color: Colors.red,
                size: 38,
              ),
            ),

            //-------------------------------
            // Checkpoint
            //-------------------------------

            ...tracking.route.checkpoints.map(

              (cp) => Marker(

                point: LatLng(
                  cp.lat,
                  cp.lng,
                ),

                width: 45,
                height: 45,

                child: const Icon(
                  Icons.location_pin,
                  color: Colors.orange,
                  size: 30,
                ),
              ),

            ),

            //-------------------------------
            // Bus
            //-------------------------------

            Marker(
              point: busLocation,

              width: 70,
              height: 70,

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                    )
                  ],
                ),

                child: const Icon(
                  Icons.directions_bus,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}