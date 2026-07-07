import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/report_provider.dart';

import '../widgets/super_admin_sidebar.dart';
import 'widgets/company_bar_chart.dart';
import 'widgets/role_pie_chart.dart';
import 'widgets/company_table.dart';
import 'widgets/driver_table.dart';
import 'widgets/bus_table.dart';
import 'widgets/schedule_table.dart';

class SuperAdminReportScreen extends StatefulWidget {
  const SuperAdminReportScreen({super.key});

  @override
  State<SuperAdminReportScreen> createState() => _SuperAdminReportScreenState();
}

class _SuperAdminReportScreenState extends State<SuperAdminReportScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SuperAdminSidebar(
            selectedMenu: 3,

            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/super-admin");
                  break;

                case 1:
                  context.go("/company-management");
                  break;

                case 2:
                  context.go("/user-management");
                  break;

                case 3:
                  context.go("/super-admin-report");
                  break;

                case 99:
                  context.go("/login");
                  break;
              }
            },
          ),

          Expanded(
            child: Consumer<ReportProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return _buildBody(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ReportProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Laporan Super Admin",

            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          Wrap(
            spacing: 20,

            runSpacing: 20,

            children: [
              statisticCard(
                "Total User",

                provider.totalUsers.toString(),

                Icons.people,

                Colors.blue,
              ),

              statisticCard(
                "Perusahaan",

                provider.totalCompanies.toString(),

                Icons.business,

                Colors.green,
              ),

              statisticCard(
                "Driver",

                provider.totalDrivers.toString(),

                Icons.person,

                Colors.orange,
              ),

              statisticCard(
                "Bus",

                provider.totalBuses.toString(),

                Icons.directions_bus,

                Colors.red,
              ),

              statisticCard(
                "Jadwal",

                provider.totalSchedules.toString(),

                Icons.calendar_month,

                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            "Statistik akan tampil di sini",

            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(child: RolePieChart(data: provider.roleStatistic)),

              const SizedBox(width: 20),

              Expanded(
                child: CompanyBarChart(companies: provider.companyStatistic),
              ),
            ],
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: CompanyTable(
              companies: provider.companyStatistic,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: DriverTable(
              drivers: provider.drivers,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: BusTable(
              buses: provider.buses,
            ),
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ScheduleTable(
              schedules: provider.schedules,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget statisticCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 260,

      child: Card(
        elevation: 4,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Row(
            children: [
              CircleAvatar(
                radius: 30,

                backgroundColor: color.withOpacity(.15),

                child: Icon(icon, color: color, size: 30),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(title, style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 6),

                    Text(
                      value,

                      style: const TextStyle(
                        fontSize: 28,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
