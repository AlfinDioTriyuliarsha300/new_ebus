import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PassengerTrackingInputScreen extends StatefulWidget {
  const PassengerTrackingInputScreen({super.key});

  @override
  State<PassengerTrackingInputScreen> createState() =>
      _PassengerTrackingInputScreenState();
}

class _PassengerTrackingInputScreenState
    extends State<PassengerTrackingInputScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Penumpang")),

      body: Center(
        child: SizedBox(
          width: 400,

          child: Card(
            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.confirmation_number,
                    size: 70,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Masukkan Nomor Tiket",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Nomor Tiket",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Nomor tiket harus diisi"),
                            ),
                          );

                          return;
                        }

                        context.push("/passenger-tracking/${controller.text}");
                      },

                      child: const Text("Lacak Bus"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
