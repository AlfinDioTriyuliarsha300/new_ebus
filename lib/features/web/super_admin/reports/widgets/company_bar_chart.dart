import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CompanyBarChart extends StatelessWidget {
  final List<dynamic> companies;

  const CompanyBarChart({super.key, required this.companies});

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const Center(child: Text("Belum ada data"));
    }

    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Jumlah Driver per Perusahaan",

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 300,

              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,

                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),

                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,

                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();

                          if (index >= companies.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),

                            child: Text(
                              companies[index]["company_name"],

                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups: List.generate(companies.length, (index) {
                    final total = int.parse(
                      companies[index]["total_driver"].toString(),
                    );

                    return BarChartGroupData(
                      x: index,

                      barRods: [
                        BarChartRodData(toY: total.toDouble(), width: 25),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
