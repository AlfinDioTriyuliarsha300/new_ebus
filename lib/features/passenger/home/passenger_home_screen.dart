import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/ticket_provider.dart';
import 'widgets/available_bus_card.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().loadBus();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<TicketProvider>();

    return Scaffold(

      appBar: AppBar(
        title: const Text("E-Bus"),
        centerTitle: true,
      ),

      body: RefreshIndicator(

        onRefresh: () async {
          await provider.loadBus();
        },

        child: provider.loading

            ? const Center(
                child: CircularProgressIndicator(),
              )

            : provider.listBus.isEmpty

                ? ListView(
                    children: const [

                      SizedBox(height: 180),

                      Icon(
                        Icons.directions_bus_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 20),

                      Center(
                        child: Text(
                          "Belum ada bus tersedia",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

                    ],
                  )

                : ListView(

                    padding: const EdgeInsets.all(16),

                    children: [

                      const Text(
                        "Bus Tersedia",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...provider.listBus.map(

                        (bus) => AvailableBusCard(
                          bus: bus,
                        ),

                      ),

                    ],
                  ),
      ),
    );
  }
}