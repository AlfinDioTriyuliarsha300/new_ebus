import 'package:flutter/material.dart';

import '../../../../providers/driver_tracking_provider.dart';

class TrackingControlCard extends StatelessWidget {
  final DriverTrackingProvider provider;
  final int? driverId;

  const TrackingControlCard({
    super.key,
    required this.provider,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    final tracking = provider.isTracking;

    return Card(
      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                icon: Icon(
                  tracking
                      ? Icons.stop
                      : Icons.play_arrow,
                ),

                label: Text(
                  tracking
                      ? "Stop Tracking"
                      : "Mulai Tracking",
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      tracking
                          ? Colors.red
                          : Colors.green,

                  foregroundColor: Colors.white,

                  minimumSize: const Size(
                    double.infinity,
                    55,
                  ),
                ),

                onPressed: driverId == null
                    ? null
                    : () async {

                        if (tracking) {

                          await provider.stopTracking(
                            driverId!,
                          );

                        } else {

                          await provider.startTracking(
                            driverId!,
                          );

                        }

                    },
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: tracking
                    ? Colors.green.shade50
                    : Colors.red.shade50,

                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(

                children: [

                  Icon(

                    tracking
                        ? Icons.gps_fixed
                        : Icons.gps_off,

                    color: tracking
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(width: 12),

                  Expanded(

                    child: Text(

                      tracking
                          ? "Tracking GPS sedang aktif"
                          : "Tracking GPS belum aktif",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        color: tracking
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}