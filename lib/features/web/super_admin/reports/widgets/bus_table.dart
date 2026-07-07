import 'package:flutter/material.dart';

class BusTable extends StatelessWidget {
  final List<dynamic> buses;

  const BusTable({super.key, required this.buses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Data Armada",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 350,
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Bus")),

                        DataColumn(label: Text("Plat")),

                        DataColumn(label: Text("Driver")),

                        DataColumn(label: Text("Tracking")),

                        DataColumn(label: Text("Status")),
                      ],

                      rows: buses.map((bus) {
                        return DataRow(
                          cells: [
                            DataCell(Text(bus["nomor_bus"])),

                            DataCell(Text(bus["plat_nomor"])),

                            DataCell(Text(bus["driver_name"] ?? "-")),

                            DataCell(
                              Icon(
                                bus["is_tracking"]
                                    ? Icons.check_circle
                                    : Icons.cancel,

                                color: bus["is_tracking"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),

                            DataCell(Text(bus["status"])),
                          ],
                        );
                      }).toList(),
                    ),
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
