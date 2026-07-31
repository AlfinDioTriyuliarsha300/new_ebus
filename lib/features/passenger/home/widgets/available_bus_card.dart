import 'package:flutter/material.dart';

import '../../../../models/ticket_bus_model.dart';
import 'buy_ticket_bottom_sheet.dart';

class AvailableBusCard extends StatelessWidget {
  final TicketBusModel bus;

  const AvailableBusCard({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Nomor Bus
            Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.blue),

                const SizedBox(width: 10),

                Text(
                  "Bus ${bus.nomorBus}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildItem(Icons.business, "Perusahaan", bus.company),

            _buildItem(Icons.route, "Rute", bus.route),

            _buildItem(Icons.calendar_month, "Tanggal", bus.tanggalFormatted),

            _buildItem(Icons.access_time, "Jam", bus.jamBerangkat),

            _buildItem(Icons.payments, "Harga", bus.hargaFormatted),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),

                label: const Text("BELI TIKET"),

                onPressed: () {
                  showModalBottomSheet(
                    context: context,

                    isScrollControlled: true,

                    builder: (_) => BuyTicketBottomSheet(bus: bus),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),

          const SizedBox(width: 10),

          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
