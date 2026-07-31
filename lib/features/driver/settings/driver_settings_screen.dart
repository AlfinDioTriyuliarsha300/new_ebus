import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/driver_dashboard_provider.dart';
import '../../../core/constants/storage_keys.dart';

import '../profile/driver_profile_screen.dart';

class DriverSettingsScreen extends StatelessWidget {
  const DriverSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Driver"), centerTitle: true),

      body: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            color: Colors.blue,

            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 35),
                ),

                const SizedBox(height: 12),

                Consumer<DriverDashboardProvider>(
                  builder: (_, provider, __) {
                    final data = provider.dashboard;

                    return Column(
                      children: [
                        Text(
                          data?.driverName ?? "-",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          data?.companyName ?? "-",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Bus ${data?.nomorBus ?? "-"}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),

            title: const Text("Profil Driver"),

            subtitle: const Text("Lihat informasi driver"),

            trailing: const Icon(Icons.chevron_right),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DriverProfileScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.refresh),

            title: const Text("Refresh Data"),

            subtitle: const Text("Mengambil data terbaru"),

            onTap: () async {
              final prefs = await SharedPreferences.getInstance();

              final userId = prefs.getInt(StorageKeys.userId);

              if (userId == null) return;

              await context.read<DriverDashboardProvider>().loadDashboard(
                userId,
              );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data berhasil diperbarui")),
                );
              }
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),

            title: const Text("Tentang Aplikasi"),

            subtitle: const Text("E-Bus Driver"),

            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "E-Bus Driver",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2026 E-Bus",
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.lock_outline),

            title: const Text("Ubah Password"),

            subtitle: const Text("Segera tersedia"),

            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fitur masih dalam pengembangan")),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),

            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),

            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),

                    content: const Text("Apakah Anda yakin ingin logout?"),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Batal"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );

              if (result == true) {
                try {
                  // nanti stop tracking dipanggil di sini
                  await auth.logout();

                  if (!context.mounted) return;

                  context.go("/login");
                } catch (_) {}

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    (_) => false,
                  );
                }
              }
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
