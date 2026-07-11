import 'package:flutter/material.dart';

import '../../../../providers/driver_tracking_provider.dart';

class TrackingInfoCard extends StatelessWidget {
  final DriverTrackingProvider provider;

  const TrackingInfoCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final tracking = provider.trackingData;

    final route = tracking?.route;

    if (tracking == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Informasi Armada",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const Divider(height: 25),

            _item(Icons.directions_bus, "Nomor Bus", tracking.bus.nomorBus),

            _item(Icons.credit_card, "Plat Nomor", tracking.bus.platNomor),

            _item(Icons.person, "Driver", tracking.driver.nama),

            _item(Icons.route, "Rute", route?.nama ?? "-"),

            _item(Icons.flag, "Terminal Awal", route?.terminalAwal.nama ?? "-"),

            _item(
              Icons.outlined_flag,
              "Terminal Tujuan",
              route?.terminalTujuan.nama ?? "-",
            ),

            _item(
              Icons.location_on,
              "Latitude",
              tracking.location.lat.toStringAsFixed(6),
            ),

            _item(
              Icons.location_searching,
              "Longitude",
              tracking.location.lng.toStringAsFixed(6),
            ),

            _item(Icons.info, "Status Bus", tracking.bus.status),

            _item(
              Icons.location_pin,
              "Zona Saat Ini",
              tracking.location.currentZone,
            ),

            _item(
              Icons.map,
              "Status Zona",
              tracking.location.currentZoneStatus,
            ),

            _item(
              Icons.alt_route,
              "Route Index",
              tracking.location.routeIndex.toString(),
            ),

            _item(
              Icons.speed,
              "Kecepatan",
              "${tracking.location.speed.toStringAsFixed(1)} km/jam",
            ),

            _item(
              Icons.gps_fixed,
              "Tracking",
              tracking.bus.tracking ? "Aktif" : "Tidak Aktif",
            ),

            _item(
              Icons.place,
              "Jumlah Checkpoint",
              (route?.checkpoints.length ?? 0).toString(),
            ),

            const SizedBox(height: 15),

            const Text(
              "Progress Perjalanan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
              value: tracking.location.progress / 100,
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${tracking.location.progress.toStringAsFixed(1)} %",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        children: [
          Icon(icon, color: Colors.blue),

          const SizedBox(width: 15),

          Expanded(
            flex: 2,

            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
