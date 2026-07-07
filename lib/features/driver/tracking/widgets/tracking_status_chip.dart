import 'package:flutter/material.dart';

class TrackingStatusChip extends StatelessWidget {
  final bool tracking;
  final bool gpsActive;

  const TrackingStatusChip({
    super.key,
    required this.tracking,
    required this.gpsActive,
  });

  @override
  Widget build(BuildContext context) {

    return Wrap(

      spacing: 10,

      children: [

        Chip(

          avatar: Icon(

            tracking
                ? Icons.circle
                : Icons.pause_circle,

            color: tracking
                ? Colors.green
                : Colors.red,

            size: 14,
          ),

          label: Text(
            tracking
                ? "LIVE TRACKING"
                : "TRACKING OFF",
          ),

          backgroundColor:
              tracking
                  ? Colors.green.shade50
                  : Colors.red.shade50,
        ),

        Chip(

          avatar: Icon(

            gpsActive
                ? Icons.gps_fixed
                : Icons.gps_off,

            color:
                gpsActive
                    ? Colors.blue
                    : Colors.grey,
          ),

          label: Text(

            gpsActive
                ? "GPS Aktif"
                : "GPS Mati",
          ),
        ),
      ],
    );
  }
}