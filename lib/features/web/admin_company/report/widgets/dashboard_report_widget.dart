import 'package:flutter/material.dart';

class DashboardReportWidget
    extends StatelessWidget {

  const DashboardReportWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Column(

        children: [

          // ==========================
          // CARD STATISTIK
          // ==========================

          GridView.count(

            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            crossAxisCount: 4,

            crossAxisSpacing: 15,

            mainAxisSpacing: 15,

            childAspectRatio: 1.8,

            children: const [

              _StatCard(
                title: "Total Armada",
                value: "15",
                icon: Icons.directions_bus,
              ),

              _StatCard(
                title: "Armada Aktif",
                value: "12",
                icon: Icons.check_circle,
              ),

              _StatCard(
                title: "Total Driver",
                value: "18",
                icon: Icons.person,
              ),

              _StatCard(
                title: "Total Trip",
                value: "125",
                icon: Icons.route,
              ),
            ],
          ),

          const SizedBox(height: 30),

          // ==========================
          // GRAFIK SEMENTARA
          // ==========================

          Card(

            elevation: 3,

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Statistik Perjalanan",

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(

                    height: 300,

                    child: Column(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,

                      children: [

                        _buildBar(
                          "Senin",
                          70,
                        ),

                        _buildBar(
                          "Selasa",
                          90,
                        ),

                        _buildBar(
                          "Rabu",
                          60,
                        ),

                        _buildBar(
                          "Kamis",
                          85,
                        ),

                        _buildBar(
                          "Jumat",
                          100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    String hari,
    double persen,
  ) {

    return Row(

      children: [

        SizedBox(
          width: 80,
          child: Text(hari),
        ),

        Expanded(
          child: LinearProgressIndicator(
            value: persen / 100,
            minHeight: 20,
            borderRadius:
                BorderRadius.circular(20),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          "$persen %",
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 3,

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              value,

              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}