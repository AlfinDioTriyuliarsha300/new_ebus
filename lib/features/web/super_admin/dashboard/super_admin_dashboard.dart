import 'package:flutter/material.dart';

import '../widgets/super_admin_sidebar.dart';
import 'package:go_router/go_router.dart';

class SuperAdminDashboard
    extends StatelessWidget {

  const SuperAdminDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(

        children: [

          SuperAdminSidebar(
            selectedMenu: 0,

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

            child: Padding(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Dashboard Super Admin",

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Wrap(

                    spacing: 20,
                    runSpacing: 20,

                    children: [

                      dashboardCard(
                        "Total Perusahaan",
                        "0",
                        Icons.business,
                      ),

                      dashboardCard(
                        "Total Armada",
                        "0",
                        Icons.directions_bus,
                      ),

                      dashboardCard(
                        "Total User",
                        "0",
                        Icons.people,
                      ),

                      dashboardCard(
                        "Armada Aktif",
                        "0",
                        Icons.location_on,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
  ) {

    return SizedBox(

      width: 280,

      child: Card(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Row(

            children: [

              Icon(
                icon,
                size: 45,
              ),

              const SizedBox(width: 15),

              Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(title),

                  Text(
                    value,

                    style:
                        const TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}