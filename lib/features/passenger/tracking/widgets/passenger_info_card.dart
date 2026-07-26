import 'package:flutter/material.dart';

import '../../../../providers/passenger_tracking_provider.dart';

class PassengerTrackingInfoCard extends StatelessWidget {
  final PassengerTrackingProvider provider;

  const PassengerTrackingInfoCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final tracking = provider.trackingData;

    if (tracking == null) {
      return const SizedBox();
    }

    Color statusColor;

    switch (tracking.bus.status) {
      case "Siap Berangkat":
        statusColor = Colors.green;
        break;

      case "Perjalanan":
        statusColor = Colors.blue;
        break;

      case "Selesai":
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //------------------------------------
            // HEADER
            //------------------------------------
            Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.blue),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    tracking.bus.nomorBus,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tracking.bus.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            //------------------------------------
            // INFORMASI
            //------------------------------------
            _buildRow(Icons.business, "Perusahaan", tracking.company),

            _buildRow(Icons.credit_card, "Nomor Tiket", tracking.ticket.nomor),

            _buildRow(Icons.pin_drop, "Trayek", tracking.route?.nama ?? "-"),

            _buildRow(
              Icons.directions_bus,
              "Plat Nomor",
              tracking.bus.platNomor,
            ),

            _buildRow(
              Icons.speed,
              "Kecepatan",
              "${tracking.location.speed.toStringAsFixed(1)} km/jam",
            ),

            _buildRow(
              Icons.location_on,
              "Zona",
              tracking.location.currentZone ?? "-",
            ),

            _buildRow(
              Icons.my_location,
              "Status Zona",
              tracking.location.currentZoneStatus ?? "-",
            ),

            const SizedBox(height: 18),

            _buildGeofenceStatus(
              tracking.location.currentZone,
              tracking.location.currentZoneStatus,
            ),

            const SizedBox(height: 18),

            //------------------------------------
            // PROGRESS
            //------------------------------------
            Row(
              children: [
                const Text(
                  "Progress Perjalanan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const Spacer(),

                Text(
                  "${tracking.location.progress.toStringAsFixed(0)} %",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: tracking.location.progress / 100,
                minHeight: 10,
                color: statusColor,
                backgroundColor: Colors.grey.shade300,
              ),
            ),

            const SizedBox(height: 18),

            //------------------------------------
            // UPDATE TERAKHIR
            //------------------------------------
            Row(
              children: [
                const Icon(Icons.access_time, size: 18),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    tracking.location.updatedAt ?? "-",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),

          const SizedBox(width: 12),

          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildGeofenceStatus(String? zone, String? status) {
    Color color = Colors.grey;
    IconData icon = Icons.location_off;
    String text = "Belum berada pada area geofence";

    if (zone != null && status != null) {
      switch (status.toLowerCase()) {
        case "inside":
          color = Colors.green;
          icon = Icons.check_circle;
          text = "Bus berada di dalam $zone";
          break;

        case "enter":
          color = Colors.orange;
          icon = Icons.login;
          text = "Bus memasuki $zone";
          break;

        case "exit":
          color = Colors.red;
          icon = Icons.logout;
          text = "Bus keluar dari $zone";
          break;

        default:
          color = Colors.blue;
          icon = Icons.location_on;
          text = "$status : $zone";
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
