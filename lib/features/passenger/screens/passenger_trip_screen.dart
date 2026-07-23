import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/ticket_provider.dart';

class PassengerTripScreen extends StatefulWidget {
  const PassengerTripScreen({super.key});

  @override
  State<PassengerTripScreen> createState() => _PassengerTripScreenState();
}

class _PassengerTripScreenState extends State<PassengerTripScreen> {
  @override
  void initState() {
    super.initState();

    loadTicket();
  }

  Future<void> loadTicket() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt("user_id");

    if (userId == null) {
      return;
    }

    if (!mounted) {
      return;
    }
    context.read<TicketProvider>().loadTickets(userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.tickets.isEmpty) {
      return const Center(
        child: Text(
          "Belum Ada Perjalanan",

          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: provider.tickets.length,

      itemBuilder: (context, index) {
        final ticket = provider.tickets[index];

        return Card(
          elevation: 4,

          margin: const EdgeInsets.only(bottom: 15),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  ticket.nomorBus,

                  style: const TextStyle(
                    fontSize: 20,

                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text("Plat Nomor : ${ticket.platNomor}"),

                Text("Nomor Tiket : ${ticket.ticketNumber}"),

                Text("Penumpang : ${ticket.passengerName}"),

                Text("Kursi : ${ticket.seatNumber}"),

                Text("Status : ${ticket.status}"),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.location_on),

                    label: const Text("Lacak Bus"),

                    onPressed: () {
                      context.push(
                        "/passenger-tracking/${ticket.ticketNumber}",

                        extra: ticket.busId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
