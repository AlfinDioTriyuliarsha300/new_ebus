import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/sidebar.dart';
import 'widgets/dashboard_card.dart';

class AdminCompanyDashboard extends StatelessWidget {
  const AdminCompanyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 0,

            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/admin-company");
                  break;

                case 1:
                  context.go("/armada");
                  break;

                case 2:
                  context.go("/route");
                  break;

                case 3:
                  context.go("/schedule");
                  break;

                case 4:
                  context.go("/driver");
                  break;

                case 5:
                  context.go("/monitoring");
                  break;

                case 6:
                  context.go("/report");
                  break;

                case 7:
                  context.go("/setting");
                  break;

                case 99:
                  context.go("/login");
                  break;
              }
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Dashboard Admin Perusahaan",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 4,

                      crossAxisSpacing: 20,

                      mainAxisSpacing: 20,

                      children: const [
                        DashboardCard(
                          title: "Armada",
                          value: "0",
                          icon: Icons.directions_bus,
                        ),

                        DashboardCard(
                          title: "Driver",
                          value: "0",
                          icon: Icons.person,
                        ),

                        DashboardCard(
                          title: "Rute",
                          value: "0",
                          icon: Icons.route,
                        ),

                        DashboardCard(
                          title: "Jadwal",
                          value: "0",
                          icon: Icons.schedule,
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
}