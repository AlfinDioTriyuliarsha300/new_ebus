import 'package:flutter/material.dart';

class ActiveTicketCard extends StatelessWidget {
  final VoidCallback onTracking;

  const ActiveTicketCard({super.key, required this.onTracking});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tiket Aktif",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Divider(),

            const SizedBox(height: 8),

            const Text("Nomor Tiket"),
            const Text(
              "EBUS-000001",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("Bus"),
            const Text("BUS-01", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            const Text("Status"),
            const Text(
              "Menunggu Keberangkatan",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTracking,
                icon: const Icon(Icons.location_on),
                label: const Text("Lacak Bus"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
