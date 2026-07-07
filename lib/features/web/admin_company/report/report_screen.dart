import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/sidebar.dart';

import 'widgets/trip_report_widget.dart';
import 'widgets/geofence_report_widget.dart';
import 'widgets/bus_performance_report_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  DateTimeRange? selectedDate;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final result = await showDateRangePicker(
      context: context,

      firstDate: DateTime(2024),

      lastDate: DateTime(2035),
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // =====================
          // SIDEBAR
          // =====================
          AdminSidebar(
            selectedMenu: 7,
            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/admin-company");
                  break;
                case 1:
                  context.go("/terminal");
                  break;
                case 2:
                  context.go("/armada");
                  break;
                case 3:
                  context.go("/route");
                  break;
                case 4:
                  context.go("/schedule");
                  break;
                case 5:
                  context.go("/driver");
                  break;
                case 6:
                  context.go("/monitoring");
                  break;
                case 7:
                  context.go("/report");
                  break;
                case 8:
                  context.go("/setting");
                  break;
                case 99:
                  context.go("/login");
                  break;
              }
            },
          ),

          // =====================
          // CONTENT
          // =====================
          Expanded(
            child: Container(
              color: Colors.grey.shade100,

              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Laporan",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // =====================
                    // SUMMARY CARD
                    // =====================
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,

                      children: [
                        SizedBox(
                          width: 300,
                          child: _summaryCard(
                            "Total Perjalanan",
                            "324",
                            Icons.route,
                            Colors.blue,
                          ),
                        ),

                        SizedBox(
                          width: 300,
                          child: _summaryCard(
                            "Total Jarak",
                            "12.450 Km",
                            Icons.map,
                            Colors.green,
                          ),
                        ),

                        SizedBox(
                          width: 300,
                          child: _summaryCard(
                            "Armada Aktif",
                            "15",
                            Icons.directions_bus,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // =====================
                    // FILTER
                    // =====================
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      crossAxisAlignment: WrapCrossAlignment.center,

                      children: [
                        ElevatedButton.icon(
                          onPressed: pickDate,

                          icon: const Icon(Icons.date_range),

                          label: Text(
                            selectedDate == null
                                ? "Pilih Tanggal"
                                : "${selectedDate!.start.day}/${selectedDate!.start.month}/${selectedDate!.start.year}"
                                      " - "
                                      "${selectedDate!.end.day}/${selectedDate!.end.month}/${selectedDate!.end.year}",
                          ),
                        ),

                        SizedBox(
                          width: 250,

                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Filter Bus",
                            ),

                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text("Semua Armada"),
                              ),
                            ],

                            onChanged: (v) {},
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {},

                          icon: const Icon(Icons.picture_as_pdf),

                          label: const Text("Export PDF"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {},

                          icon: const Icon(Icons.table_view),

                          label: const Text("Export Excel"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // =====================
                    // TAB BAR
                    // =====================
                    SizedBox(
                      width: double.infinity,

                      child: TabBar(
                        controller: _tabController,

                        tabs: const [
                          Tab(text: "Perjalanan"),
                          Tab(text: "Geofence"),
                          Tab(text: "Performa"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =====================
                    // TAB VIEW
                    // =====================
                    SizedBox(
                      height: 700,

                      child: TabBarView(
                        controller: _tabController,

                        children: const [
                          TripReportWidget(),

                          GeofenceReportWidget(),

                          BusPerformanceReportWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Row(
          children: [
            CircleAvatar(
              radius: 28,

              backgroundColor: color.withOpacity(0.2),

              child: Icon(icon, color: color, size: 30),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),

                Text(
                  value,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
