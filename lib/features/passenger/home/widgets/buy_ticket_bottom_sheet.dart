import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ticket_result_dialog.dart';

import '../../../../models/ticket_bus_model.dart';
import '../../../../providers/ticket_provider.dart';

class BuyTicketBottomSheet extends StatefulWidget {
  final TicketBusModel bus;

  const BuyTicketBottomSheet({super.key, required this.bus});

  @override
  State<BuyTicketBottomSheet> createState() => _BuyTicketBottomSheetState();
}

class _BuyTicketBottomSheetState extends State<BuyTicketBottomSheet> {
  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TicketProvider>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Beli Tiket",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Card(
                color: Colors.grey.shade100,
                child: ListTile(
                  leading: const Icon(Icons.directions_bus),
                  title: Text("Bus ${widget.bus.nomorBus}"),
                  subtitle: Text("${widget.bus.company}\n${widget.bus.route}"),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Penumpang",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Nomor HP",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: provider.loading
                      ? null
                      : () async {
                          if (_nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Nama masih kosong"),
                              ),
                            );
                            return;
                          }

                          if (_phoneController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Nomor HP masih kosong"),
                              ),
                            );
                            return;
                          }

                          final success = await provider.buyTicket(
                            bus: widget.bus,
                            passengerName: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                          );

                          if (!mounted) return;

                          if (success) {
                            Navigator.pop(context);

                            showDialog(
                              context: context,

                              builder: (_) => TicketResultDialog(
                                success: true,

                                message:
                                    "Nomor Tiket\n\n${provider.ticketNumber}",

                                onViewTrip: () {
                                  Navigator.pop(context);

                                  Navigator.pushNamed(
                                    context,
                                    "/passenger-trip",
                                  );
                                },
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,

                              builder: (_) => TicketResultDialog(
                                success: false,

                                message:
                                    provider.errorMessage ?? "Pembelian gagal",
                              ),
                            );
                          }
                        },
                  child: provider.loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text("BELI TIKET"),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
