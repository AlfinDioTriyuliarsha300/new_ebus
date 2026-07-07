import 'package:flutter/material.dart';

class DriverTable extends StatelessWidget {
  final List<dynamic> drivers;

  const DriverTable({super.key, required this.drivers});

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
                "Data Driver",

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
                        DataColumn(label: Text("Driver")),

                        DataColumn(label: Text("Kontak")),

                        DataColumn(label: Text("Status")),

                        DataColumn(label: Text("Perusahaan")),
                      ],

                      rows: drivers.map((driver) {
                        return DataRow(
                          cells: [
                            DataCell(Text(driver["driver_name"])),

                            DataCell(Text(driver["kontak"])),

                            DataCell(Text(driver["status"])),

                            DataCell(Text(driver["company_name"] ?? "-")),
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
