import 'package:flutter/material.dart';

class DriverScheduleCard extends StatelessWidget {
  final String route;
  final String date;
  final String departureTime;
  final String status;

  const DriverScheduleCard({
    super.key,
    required this.route,
    required this.date,
    required this.departureTime,
    required this.status,
  });

  Color get statusColor {
    switch (status.toLowerCase()) {
      case "berjalan":
        return Colors.green;

      case "mendatang":
        return Colors.orange;

      case "selesai":
        return Colors.grey;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),

      child: Padding(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                Container(
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: .12),

                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 15),

                const Text(
                  "Jadwal Hari Ini",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _item(
              Icons.route,
              "Rute",
              route,
            ),

            _item(
              Icons.date_range,
              "Tanggal",
              date,
            ),

            _item(
              Icons.access_time,
              "Berangkat",
              departureTime,
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: .12),

                borderRadius:
                    BorderRadius.circular(30),
              ),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Icon(
                    Icons.circle,
                    size: 12,
                    color: statusColor,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    status,

                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
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

  Widget _item(
    IconData icon,
    String title,
    String value,
  ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: Colors.blueGrey,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}