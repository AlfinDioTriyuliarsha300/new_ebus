import 'package:flutter/material.dart';

class DriverStatusCard extends StatelessWidget {
  final bool online;
  final String status;

  const DriverStatusCard({
    super.key,
    required this.online,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = online ? Colors.green : Colors.red;

    return Card(
      elevation: 5,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,

              backgroundColor: color.withValues(alpha: 0.15),

              child: Icon(
                online ? Icons.check_circle : Icons.cancel,

                color: color,
                size: 34,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Status Driver",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),

                borderRadius: BorderRadius.circular(30),
              ),

              child: Text(
                online ? "ONLINE" : "OFFLINE",

                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
