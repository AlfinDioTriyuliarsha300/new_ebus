import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/driver_dashboard_provider.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverDashboardProvider>();

    final dashboard = provider.dashboard;

    if (dashboard == null) {
      return const Scaffold(
        body: Center(
          child: Text("Data driver tidak ditemukan"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Driver"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 55,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              dashboard.driverName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          _item(
            Icons.business,
            "Perusahaan",
            dashboard.companyName,
          ),

          _item(
            Icons.directions_bus,
            "Nomor Bus",
            dashboard.nomorBus,
          ),

          _item(
            Icons.pin,
            "Plat Nomor",
            dashboard.platNomor,
          ),

          _item(
            Icons.route,
            "Rute",
            dashboard.routeName,
          ),

          _item(
            Icons.location_on,
            "Status Driver",
            dashboard.driverStatus,
          ),

          _item(
            Icons.gps_fixed,
            "Tracking",
            dashboard.isTracking
                ? "Sedang Berjalan"
                : "Tidak Berjalan",
          ),

          _item(
            Icons.calendar_today,
            "Tanggal Berangkat",
            dashboard.tanggal,
          ),

          _item(
            Icons.access_time,
            "Jam Berangkat",
            dashboard.jam,
          ),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        subtitle: Text(value),
      ),
    );
  }
}