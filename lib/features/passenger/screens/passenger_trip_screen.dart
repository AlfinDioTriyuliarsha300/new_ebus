import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../providers/ticket_provider.dart';
import '../tracking/passenger_tracking_screen.dart';

class PassengerTripScreen extends StatefulWidget {
  const PassengerTripScreen({super.key});

  @override
  State<PassengerTripScreen> createState() =>
      _PassengerTripScreenState();
}

class _PassengerTripScreenState
    extends State<PassengerTripScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {

    final prefs = await SharedPreferences.getInstance();

    final userId =
        prefs.getInt(StorageKeys.userId);

    if (userId == null) return;

    if (!mounted) return;

    context
        .read<TicketProvider>()
        .loadTickets(userId);
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        context.watch<TicketProvider>();

    if (provider.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perjalanan Saya"),
      ),

      body: provider.tickets.isEmpty

          ? const Center(
              child: Text(
                "Belum ada tiket.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )

          : RefreshIndicator(
              onRefresh: loadData,

              child: ListView.builder(
                padding:
                    const EdgeInsets.all(16),

                itemCount:
                    provider.tickets.length,

                itemBuilder:
                    (context, index) {

                  final ticket =
                      provider.tickets[index];

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 16,
                    ),

                    elevation: 3,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                              16),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Row(
                            children: [

                              const Icon(
                                Icons
                                    .directions_bus,
                                color:
                                    Colors.blue,
                              ),

                              const SizedBox(
                                  width: 10),

                              Text(
                                "Bus ${ticket.nomorBus}",

                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  fontSize: 20,
                                ),
                              ),

                              const Spacer(),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: ticket
                                              .status ==
                                          "Aktif"
                                      ? Colors.green
                                      : Colors.red,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              20),
                                ),

                                child: Text(
                                  ticket.status,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),

                          const Divider(
                            height: 30,
                          ),

                          Text(
                            "Nomor Tiket : ${ticket.ticketNumber}",
                          ),

                          Text(
                            "Penumpang : ${ticket.passengerName}",
                          ),

                          Text(
                            "Nomor HP : ${ticket.phone}",
                          ),

                          Text(
                            "Plat Nomor : ${ticket.platNomor}",
                          ),

                          Text(
                            "Kursi : ${ticket.seatNumber}",
                          ),

                          Text(
                            "Tanggal : ${ticket.tanggalBerangkat}",
                          ),

                          Text(
                            "Jam : ${ticket.jamBerangkat}",
                          ),

                          Text(
                            "Harga : Rp ${ticket.hargaTiket}",
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            width:
                                double.infinity,

                            child:
                                ElevatedButton.icon(

                              icon: const Icon(
                                  Icons.location_on),

                              label: const Text(
                                  "Lacak Bus"),

                              onPressed: () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        PassengerTrackingScreen(

                                      ticket:
                                          ticket.ticketNumber,

                                      busId:
                                          ticket.busId,

                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}