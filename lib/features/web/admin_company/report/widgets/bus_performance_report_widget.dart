import 'package:flutter/material.dart';

class BusPerformanceReportWidget
    extends StatelessWidget {

  const BusPerformanceReportWidget({
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

              "Laporan Performa Armada",

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
                      label: Text("Bus"),
                    ),

                    DataColumn(
                      label: Text("Driver"),
                    ),

                    DataColumn(
                      label: Text("Perjalanan"),
                    ),

                    DataColumn(
                      label: Text("Jarak"),
                    ),

                    DataColumn(
                      label: Text("Kecepatan Avg"),
                    ),

                    DataColumn(
                      label: Text("Ketepatan"),
                    ),

                    DataColumn(
                      label: Text("Ranking"),
                    ),
                  ],

                  rows: [

                    _buildRow(
                      "N 1234 AB",
                      "Budi Santoso",
                      "120",
                      "5.320 Km",
                      "48 Km/jam",
                      "98 %",
                      "1",
                    ),

                    _buildRow(
                      "N 2233 BC",
                      "Andi Prasetyo",
                      "98",
                      "4.120 Km",
                      "45 Km/jam",
                      "95 %",
                      "2",
                    ),

                    _buildRow(
                      "N 8877 DE",
                      "Slamet Riyadi",
                      "85",
                      "3.800 Km",
                      "44 Km/jam",
                      "90 %",
                      "3",
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

    String bus,

    String driver,

    String perjalanan,

    String jarak,

    String kecepatan,

    String ketepatan,

    String ranking,

  ) {

    return DataRow(

      cells: [

        DataCell(Text(bus)),

        DataCell(Text(driver)),

        DataCell(Text(perjalanan)),

        DataCell(Text(jarak)),

        DataCell(Text(kecepatan)),

        DataCell(Text(ketepatan)),

        DataCell(

          Container(

            width: 35,
            height: 35,

            alignment: Alignment.center,

            decoration: BoxDecoration(

              color: Colors.blue,

              borderRadius:
                  BorderRadius.circular(30),
            ),

            child: Text(

              ranking,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}