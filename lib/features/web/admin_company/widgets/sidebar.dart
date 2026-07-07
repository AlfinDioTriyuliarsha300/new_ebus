import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedMenu;

  final Function(int) onMenuSelected;

  const AdminSidebar({
    super.key,
    required this.selectedMenu,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.blueGrey.shade900,

      child: Column(
        children: [
          const SizedBox(height: 30),

          const Icon(Icons.directions_bus, color: Colors.white, size: 60),

          const SizedBox(height: 10),

          const Text(
            "E-BUS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          _menu("Dashboard", Icons.dashboard, 0),

          _menu("Manajemen Terminal", Icons.location_city, 1),

          _menu("Manajemen Armada", Icons.directions_bus, 2),

          _menu("Manajemen Rute", Icons.route, 3),

          _menu("Manajemen Jadwal", Icons.schedule, 4),

          _menu("Manajemen Driver", Icons.person, 5),

          _menu("Monitoring Bus", Icons.location_on, 6),

          _menu("Laporan", Icons.bar_chart, 7),

          _menu("Pengaturan Akun", Icons.settings, 8),

          const Spacer(),

          _menu("Logout", Icons.logout, 99),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menu(String title, IconData icon, int index) {
    return ListTile(
      selected: selectedMenu == index,

      selectedTileColor: Colors.blueGrey,

      leading: Icon(icon, color: Colors.white),

      title: Text(title, style: const TextStyle(color: Colors.white)),

      onTap: () {
        onMenuSelected(index);
      },
    );
  }
}
