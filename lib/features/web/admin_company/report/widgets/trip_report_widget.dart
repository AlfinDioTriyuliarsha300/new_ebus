import 'package:flutter/material.dart';

class TripReportWidget extends StatelessWidget {
  const TripReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Laporan Perjalanan Armada",

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    Colors.grey.shade200,
                  ),

                  columns: const [
                    DataColumn(label: Text("Tanggal")),

                    DataColumn(label: Text("Bus")),

                    DataColumn(label: Text("Driver")),

                    DataColumn(label: Text("Rute")),

                    DataColumn(label: Text("Berangkat")),

                    DataColumn(label: Text("Tiba")),

                    DataColumn(label: Text("Status")),
                  ],

                  rows: [
                    _buildRow(
                      "27/06/2026",
                      "N 1234 AB",
                      "Budi Santoso",
                      "Malang - Surabaya",
                      "08:00",
                      "10:30",
                      "Selesai",
                    ),

                    _buildRow(
                      "27/06/2026",
                      "N 2233 BC",
                      "Andi Prasetyo",
                      "Malang - Blitar",
                      "09:00",
                      "-",
                      "Berjalan",
                    ),

                    _buildRow(
                      "27/06/2026",
                      "N 8877 DE",
                      "Slamet Riyadi",
                      "Malang - Kediri",
                      "07:00",
                      "09:15",
                      "Selesai",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRow(
    String tanggal,

    String bus,

    String driver,

    String rute,

    String berangkat,

    String tiba,

    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(tanggal)),

        DataCell(Text(bus)),

        DataCell(Text(driver)),

        DataCell(Text(rute)),

        DataCell(Text(berangkat)),

        DataCell(Text(tiba)),

        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: status == "Selesai"
                  ? Colors.green.shade100
                  : Colors.orange.shade100,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(status),
          ),
        ),
      ],
    );
  }
}
