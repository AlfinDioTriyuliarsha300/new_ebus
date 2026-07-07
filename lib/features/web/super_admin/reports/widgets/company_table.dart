import 'package:flutter/material.dart';

class CompanyTable extends StatelessWidget {
  final List<dynamic> companies;

  const CompanyTable({super.key, required this.companies});

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
                "Data Perusahaan",

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
                        DataColumn(label: Text("Perusahaan")),

                        DataColumn(label: Text("Status")),

                        DataColumn(label: Text("Driver")),

                        DataColumn(label: Text("Bus")),

                        DataColumn(label: Text("Rute")),

                        DataColumn(label: Text("Jadwal")),
                      ],

                      rows: companies.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item["company_name"])),

                            DataCell(Text(item["status"])),

                            DataCell(Text(item["total_driver"].toString())),

                            DataCell(Text(item["total_bus"].toString())),

                            DataCell(Text(item["total_route"].toString())),

                            DataCell(Text(item["total_schedule"].toString())),
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
