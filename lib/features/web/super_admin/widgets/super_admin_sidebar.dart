import 'package:flutter/material.dart';

class SuperAdminSidebar extends StatelessWidget {
  final int selectedMenu;

  final Function(int) onMenuSelected;

  const SuperAdminSidebar({
    super.key,
    required this.selectedMenu,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,

      color: Colors.blueGrey.shade900,

      child: Column(
        children: [

          const SizedBox(height: 40),

          const Text(
            "SUPER ADMIN",

            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          _menuItem(
            0,
            Icons.dashboard,
            "Dashboard",
          ),

          _menuItem(
            1,
            Icons.business,
            "Perusahaan",
          ),

          _menuItem(
            2,
            Icons.people,
            "User",
          ),

          _menuItem(
            3,
            Icons.analytics,
            "Laporan",
          ),

          const Spacer(),

          _menuItem(
            99,
            Icons.logout,
            "Logout",
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem(
    int index,
    IconData icon,
    String title,
  ) {

    final selected =
        selectedMenu == index;

    return ListTile(
      selected: selected,

      selectedTileColor:
          Colors.white24,

      leading: Icon(
        icon,
        color: Colors.white,
      ),

      title: Text(
        title,

        style: const TextStyle(
          color: Colors.white,
        ),
      ),

      onTap: () =>
          onMenuSelected(index),
    );
  }
}