import 'package:flutter/material.dart';
import 'package:new_ebus/models/passenger_tracking_model.dart';

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

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        color: statusColor.withValues(alpha: .20),
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
                _buildRow(
                  Icons.credit_card,
                  "Nomor Tiket",
                  tracking.ticket.nomor,
                ),
                _buildRow(
                  Icons.pin_drop,
                  "Trayek",
                  tracking.route?.nama ?? "-",
                ),
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

                const SizedBox(height: 20),

                const Divider(),

                const SizedBox(height: 10),

                const Text(
                  "Progress Perjalanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 18),

                _buildRouteProgress(tracking),

                const SizedBox(height: 22),

                _buildEstimateCard(tracking),

                const SizedBox(height: 22),

                const Text(
                  "Riwayat Geofence",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                const SizedBox(height: 10),

                ...provider.geofenceHistory.map(_buildHistoryTile),

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
        color: color.withValues(alpha: .12),
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

  Widget _buildHistoryTile(GeofenceHistory item) {
    Color color;
    IconData icon;

    switch (item.status.toLowerCase()) {
      case "enter":
        color = Colors.green;
        icon = Icons.login;
        break;

      case "inside":
        color = Colors.blue;
        icon = Icons.location_on;
        break;

      case "exit":
        color = Colors.red;
        icon = Icons.logout;
        break;

      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    final time =
        "${item.time.hour.toString().padLeft(2, '0')}:"
        "${item.time.minute.toString().padLeft(2, '0')}:"
        "${item.time.second.toString().padLeft(2, '0')}";

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: color.withValues(alpha: .15),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(item.zone),
      subtitle: Text(time),
      trailing: Text(
        item.status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRouteProgress(PassengerTrackingModel tracking) {
    final progress = tracking.location.progress.clamp(0.0, 100.0);
    final checkpoints = tracking.route?.checkpoints ?? [];
    final totalPoint = checkpoints.length + 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final currentZone = tracking.location.currentZone?.toLowerCase() ?? "";

        int currentIndex = 0;

        // Terminal awal
        if (currentZone.contains(
          tracking.route!.terminalAwal.nama.toLowerCase(),
        )) {
          currentIndex = 0;
        }

        // Checkpoint
        for (int i = 0; i < checkpoints.length; i++) {
          if (currentZone.contains(checkpoints[i].nama.toLowerCase())) {
            currentIndex = i + 1;
          }
        }

        // Terminal tujuan
        if (currentZone.contains(
          tracking.route!.terminalTujuan.nama.toLowerCase(),
        )) {
          currentIndex = totalPoint - 1;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------
            // TERMINAL
            //----------------------------------
            SizedBox(
              height: 70,
              child: LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth;

                  final busLeft = (progress / 100) * (width - 34);

                  return Stack(
                    children: [
                      //--------------------------------
                      // GARIS BELAKANG
                      //--------------------------------
                      Positioned(
                        left: 18,
                        right: 18,
                        top: 16,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      //--------------------------------
                      // GARIS PROGRESS
                      //--------------------------------
                      Positioned(
                        left: 18,
                        top: 16,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: ((width - 36) * progress / 100),
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      //--------------------------------
                      // TITIK
                      //--------------------------------
                      Row(
                        children: List.generate(totalPoint, (index) {
                          final bool passed = index < currentIndex;
                          final bool current = index == currentIndex;

                          Icon icon;

                          if (index == 0) {
                            icon = Icon(
                              Icons.flag_circle,
                              color: current
                                  ? Colors.orange
                                  : passed
                                  ? Colors.green
                                  : Colors.grey,
                            );
                          } else if (index == totalPoint - 1) {
                            icon = Icon(
                              Icons.flag_circle,
                              color: current
                                  ? Colors.orange
                                  : passed
                                  ? Colors.red
                                  : Colors.grey,
                            );
                          } else {
                            icon = Icon(
                              Icons.location_on,
                              color: current
                                  ? Colors.orange
                                  : passed
                                  ? Colors.green
                                  : Colors.grey.shade400,
                            );
                          }

                          return Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  icon.icon,
                                  key: ValueKey(
                                    "${index}_${passed}_${current}",
                                  ),
                                  color: icon.color,
                                  size: icon.size,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      //--------------------------------
                      // BUS
                      //--------------------------------
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        left: busLeft,
                        top: 28,
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            //----------------------------------
            // PROGRESS BAR
            //----------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 10),

            //----------------------------------
            // LABEL LOKASI
            //----------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    tracking.route?.terminalAwal.nama ?? "-",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                ...checkpoints.map(
                  (cp) => Expanded(
                    child: Text(
                      cp.nama,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    tracking.route?.terminalTujuan.nama ?? "-",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Center(
              child: Text(
                "Progress : ${progress.toStringAsFixed(0)} %",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEstimateCard(PassengerTrackingModel tracking) {
    final distanceKm = tracking.location.remainingDistance / 1000;
    final speed = tracking.location.speed;
    final eta = tracking.location.estimatedMinutes;

    String etaText;
    Color etaColor;

    if (!tracking.bus.tracking) {
      etaText = "Tracking Off";
      etaColor = Colors.grey;
    } else if (tracking.location.progress >= 100) {
      etaText = "Sudah Tiba";
      etaColor = Colors.green;
    } else if (tracking.location.remainingDistance <= 500) {
      etaText = "Hampir Tiba";
      etaColor = Colors.orange;
    } else if (speed <= 1) {
      etaText = "Bus Berhenti";
      etaColor = Colors.red;
    } else {
      etaText = eta == null ? "-" : "$eta menit";
      etaColor = Colors.blue;
    }

    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.route, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Estimasi Perjalanan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _estimateItem(
                    Icons.straighten,
                    "Sisa Jarak",
                    "${distanceKm.toStringAsFixed(1)} km",
                  ),
                ),

                Expanded(
                  child: _estimateItem(
                    Icons.speed,
                    "Kecepatan",
                    "${speed.toStringAsFixed(1)} km/jam",
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.schedule, color: etaColor, size: 28),

                      const SizedBox(height: 8),

                      const Text(
                        "ETA",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        etaText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: etaColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _estimateItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 28),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
