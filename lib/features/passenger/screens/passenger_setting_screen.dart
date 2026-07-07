import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class PassengerSettingScreen extends StatelessWidget {
  const PassengerSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              subtitle: const Text("Informasi akun"),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),

              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

              onTap: () async {

                final confirm =
                    await showDialog<bool>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text(
                        "Yakin ingin keluar dari aplikasi?",
                      ),
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

                if (confirm == true) {

                  await context
                      .read<AuthProvider>()
                      .logout();

                  if (context.mounted) {
                    context.go("/login");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}