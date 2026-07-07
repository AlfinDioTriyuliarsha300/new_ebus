import 'package:flutter/material.dart';

class ScheduleTable extends StatelessWidget {
  final List<dynamic> schedules;

  const ScheduleTable({super.key, required this.schedules});

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
                "Jadwal Keberangkatan",

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
                        DataColumn(label: Text("Tanggal")),

                        DataColumn(label: Text("Jam")),

                        DataColumn(label: Text("Bus")),

                        DataColumn(label: Text("Harga")),

                        DataColumn(label: Text("Status")),
                      ],

                      rows: schedules.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item["tanggal_berangkat"])),

                            DataCell(Text(item["jam_berangkat"])),

                            DataCell(Text(item["nomor_bus"] ?? "-")),

                            DataCell(Text(item["harga_tiket"].toString())),

                            DataCell(Text(item["status"])),
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
