import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RolePieChart extends StatelessWidget {
  final List<dynamic> data;

  const RolePieChart({super.key, required this.data});

  Color getColor(int index) {
    final colors = [
      Colors.blue,

      Colors.orange,

      Colors.green,

      Colors.red,

      Colors.purple,

      Colors.teal,

      Colors.indigo,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Belum ada data"));
    }

    return Card(
      elevation: 4,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Distribusi Role User",

              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 280,

              child: PieChart(
                PieChartData(
                  sections: List.generate(data.length, (index) {
                    final item = data[index];

                    return PieChartSectionData(
                      color: getColor(index),

                      radius: 90,

                      value: double.parse(item["total"].toString()),

                      title: "${item["total"]}",

                      titleStyle: const TextStyle(
                        color: Colors.white,

                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 15,

              children: List.generate(data.length, (index) {
                final item = data[index];

                return Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(width: 14, height: 14, color: getColor(index)),

                    const SizedBox(width: 6),

                    Text(item["role"]),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
