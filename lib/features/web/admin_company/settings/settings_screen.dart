import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../providers/company_provider.dart';
import '../widgets/sidebar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final namaController = TextEditingController();

  final alamatController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final websiteController = TextEditingController();

  final oldPasswordController = TextEditingController();

  final newPasswordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  int companyId = 0;

  bool isInit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      companyId = prefs.getInt("company_id") ?? 0;

      if (!mounted) return;

      await context.read<CompanyProvider>().getCompany(companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 8,

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

          Expanded(
            child: Consumer<CompanyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.company == null) {
                  return const Center(
                    child: Text("Data perusahaan tidak ditemukan"),
                  );
                }

                if (!isInit) {
                  namaController.text = provider.company!.companyName;

                  alamatController.text = provider.company!.alamat;

                  emailController.text = provider.company!.email;

                  phoneController.text = provider.company!.telepon;

                  isInit = true;
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(30),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Pengaturan Akun",

                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Card(
                        elevation: 3,

                        child: Padding(
                          padding: const EdgeInsets.all(25),

                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 55,

                                child: Icon(Icons.business, size: 50),
                              ),

                              const SizedBox(height: 30),

                              TextField(
                                controller: namaController,

                                decoration: const InputDecoration(
                                  labelText: "Nama Perusahaan",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: alamatController,

                                decoration: const InputDecoration(
                                  labelText: "Alamat",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: emailController,

                                decoration: const InputDecoration(
                                  labelText: "Email",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: phoneController,

                                decoration: const InputDecoration(
                                  labelText: "Nomor Telepon",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: websiteController,

                                decoration: const InputDecoration(
                                  labelText: "Website",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 30),

                              SizedBox(
                                width: double.infinity,

                                height: 50,

                                child: ElevatedButton(
                                  onPressed: () async {
                                    await provider.updateCompany(
                                      companyId: companyId,

                                      namaPerusahaan: namaController.text,

                                      alamat: alamatController.text,

                                      email: emailController.text,

                                      phone: phoneController.text,

                                      website: websiteController.text,
                                    );

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Data berhasil disimpan"),
                                      ),
                                    );
                                  },

                                  child: const Text("Simpan Perubahan"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Card(
                        elevation: 3,

                        child: Padding(
                          padding: const EdgeInsets.all(25),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Ganti Password",

                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 25),

                              TextField(
                                controller: oldPasswordController,

                                obscureText: true,

                                decoration: const InputDecoration(
                                  labelText: "Password Lama",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: newPasswordController,

                                obscureText: true,

                                decoration: const InputDecoration(
                                  labelText: "Password Baru",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: confirmPasswordController,

                                obscureText: true,

                                decoration: const InputDecoration(
                                  labelText: "Konfirmasi Password",

                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,

                                height: 50,

                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (newPasswordController.text !=
                                        confirmPasswordController.text) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Konfirmasi password tidak sama",
                                          ),
                                        ),
                                      );

                                      return;
                                    }

                                    try {
                                      await provider.changePassword(
                                        companyId: companyId,

                                        oldPassword: oldPasswordController.text,

                                        newPassword: newPasswordController.text,
                                      );

                                      oldPasswordController.clear();
                                      newPasswordController.clear();
                                      confirmPasswordController.clear();

                                      if (!mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Password berhasil diubah",
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },

                                  child: const Text("Ubah Password"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),

                          title: const Text("Logout"),

                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();

                            await prefs.clear();

                            if (!mounted) return;

                            context.go("/login");
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
