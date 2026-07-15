import 'package:flutter/material.dart';
import 'package:new_ebus/features/passenger/tracking/passenger_tracking_screen.dart';
import 'package:provider/provider.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().loadTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.tickets.isEmpty) {
          return const Center(child: Text("Belum Ada Perjalanan"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: provider.tickets.length,

          itemBuilder: (context, index) {
            final ticket = provider.tickets[index];

            return Card(
              child: ListTile(
                title: Text(ticket.ticketNumber),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(ticket.platNomor),

                    Text("Seat : ${ticket.seatNumber}"),

                    Text(ticket.status),
                  ],
                ),

                trailing: const Icon(Icons.chevron_right),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PassengerTrackingScreen(
                        ticket: ticket.ticketNumber,
                        busId: ticket.busId,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
