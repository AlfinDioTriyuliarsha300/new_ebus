import 'package:flutter/material.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text("Penumpang"),
              subtitle: const Text("Saldo : Rp 0"),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade300,
            ),
            child: const Center(
              child: Text(
                "Banner Iklan",
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tiket Tersedia",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {

              return Card(
                child: ListTile(
                  title: Text(
                    "Rute ${index + 1}",
                  ),
                  subtitle: const Text(
                    "Rp 25.000",
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Pesan",
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}