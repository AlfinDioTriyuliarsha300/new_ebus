import 'package:flutter/material.dart';

class GeofenceReportWidget
    extends StatelessWidget {

  const GeofenceReportWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 3,

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              "Laporan Aktivitas Geofence",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: SingleChildScrollView(

                scrollDirection:
                    Axis.horizontal,

                child: DataTable(

                  headingRowColor:
                      WidgetStateProperty.all(
                    Colors.grey.shade200,
                  ),

                  columns: const [

                    DataColumn(
                      label: Text("Tanggal"),
                    ),

                    DataColumn(
                      label: Text("Bus"),
                    ),

                    DataColumn(
                      label: Text("Lokasi"),
                    ),

                    DataColumn(
                      label: Text("Masuk"),
                    ),

                    DataColumn(
                      label: Text("Keluar"),
                    ),

                    DataColumn(
                      label: Text("Durasi"),
                    ),

                    DataColumn(
                      label: Text("Status"),
                    ),
                  ],

                  rows: [

                    _buildRow(
                      "27/06/2026",
                      "N 1234 AB",
                      "Terminal Arjosari",
                      "08:05",
                      "08:15",
                      "10 Menit",
                      "Keluar",
                    ),

                    _buildRow(
                      "27/06/2026",
                      "N 2233 BC",
                      "Checkpoint Pandanwangi",
                      "09:20",
                      "09:25",
                      "5 Menit",
                      "Keluar",
                    ),

                    _buildRow(
                      "27/06/2026",
                      "N 8877 DE",
                      "Terminal Bungurasih",
                      "10:10",
                      "-",
                      "-",
                      "Di Dalam",
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

    String lokasi,

    String masuk,

    String keluar,

    String durasi,

    String status,

  ) {

    return DataRow(

      cells: [

        DataCell(Text(tanggal)),

        DataCell(Text(bus)),

        DataCell(Text(lokasi)),

        DataCell(Text(masuk)),

        DataCell(Text(keluar)),

        DataCell(Text(durasi)),

        DataCell(

          Container(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color: status == "Di Dalam"
                  ? Colors.orange.shade100
                  : Colors.green.shade100,

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Text(status),
          ),
        ),
      ],
    );
  }
}