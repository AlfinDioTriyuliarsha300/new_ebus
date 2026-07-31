import 'package:flutter/material.dart';
import 'package:new_ebus/features/driver/profile/driver_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/driver_dashboard_provider.dart';

import '../tracking/driver_tracking_screen.dart';

import '../settings/driver_settings_screen.dart';

import 'widgets/driver_header.dart';
import 'widgets/driver_status_card.dart';
import 'widgets/driver_bus_card.dart';
import 'widgets/driver_schedule_card.dart';
import 'widgets/quick_menu_grid.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      final userId = prefs.getInt(StorageKeys.userId);

      debugPrint("USER LOGIN = $userId");

      if (userId != null) {
        context.read<DriverDashboardProvider>().loadDashboard(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverDashboardProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.dashboard == null) {
      return const Scaffold(
        body: Center(child: Text("Data driver tidak ditemukan")),
      );
    }

    final dashboard = provider.dashboard!;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {

            final prefs =
                await SharedPreferences.getInstance();

            final userId =
                prefs.getInt(StorageKeys.userId);

            if(userId!=null){

              await provider.loadDashboard(userId);

            }

          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                DriverHeader(
                  driverName: dashboard.driverName,
                  companyName: dashboard.companyName,
                  busNumber: dashboard.nomorBus,
                ),

                const SizedBox(height: 20),

                DriverStatusCard(
                  online: dashboard.driverStatus.toLowerCase() == "aktif",
                  status: dashboard.driverStatus,
                ),

                const SizedBox(height: 20),

                DriverBusCard(
                  nomorBus: dashboard.nomorBus,
                  platNomor: dashboard.platNomor,
                  status: dashboard.busStatus,
                  tracking: dashboard.isTracking,
                ),

                const SizedBox(height: 20),

                DriverScheduleCard(
                  route: dashboard.routeName,
                  date: dashboard.tanggal,
                  departureTime: dashboard.jam,
                  status: dashboard.busStatus,
                ),

                const SizedBox(height: 25),

                QuickMenuGrid(
                  onTap: (index) {

                    switch (index) {

                      case 0:

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const DriverTrackingScreen(),

                          ),

                        );

                        break;

                      case 1:

                        // Riwayat
                        break;

                      case 2:

                        // Tiket
                        break;

                      case 3:

                        // Notifikasi
                        break;

                      case 4:

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverProfileScreen(),
                          ),
                        );

                        break;

                      case 5:

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriverSettingsScreen(),
                          ),
                        );

                        break;
                    }
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
