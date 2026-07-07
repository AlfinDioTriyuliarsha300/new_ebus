import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../providers/company_provider.dart';
import '../widgets/super_admin_sidebar.dart';

class CompanyManagementScreen extends StatefulWidget {
  const CompanyManagementScreen({super.key});

  @override
  State<CompanyManagementScreen> createState() =>
      _CompanyManagementScreenState();
}

class _CompanyManagementScreenState extends State<CompanyManagementScreen> {
  final namaController = TextEditingController();

  final alamatController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyProvider>().getCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SuperAdminSidebar(
            selectedMenu: 1,

            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/super-admin");
                  break;

                case 1:
                  context.go("/company-management");
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

              child: Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  print(provider.companies.length);
                  print(provider.companies.map((e) => e.companyName).toList());

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            "Manajemen Perusahaan",

                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(
                            width: 140,

                            child: ElevatedButton.icon(
                              onPressed: showCreateDialog,

                              icon: const Icon(Icons.add),

                              label: const Text("Tambah"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: ListView.builder(
                            itemCount: provider.companies.length,

                            itemBuilder: (context, index) {
                              final company = provider.companies[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                child: ListTile(
                                  title: Text(company.companyName),

                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        company.email.isEmpty
                                            ? "-"
                                            : company.email,
                                      ),

                                      Text(
                                        company.telepon.isEmpty
                                            ? "-"
                                            : company.telepon,
                                      ),

                                      Text(
                                        company.website.isEmpty
                                            ? "-"
                                            : company.website,
                                      ),

                                      Text("Status : ${company.status}"),
                                    ],
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      // RESET PASSWORD
                                      IconButton(
                                        icon: const Icon(
                                          Icons.lock_reset,
                                          color: Colors.orange,
                                        ),

                                        onPressed: () async {
                                          await context
                                              .read<CompanyProvider>()
                                              .resetPassword(company.id);

                                          if (mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Password berhasil direset menjadi 123456",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),

                                      // EDIT
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),

                                        onPressed: () {
                                          showEditDialog(company);
                                        },
                                      ),

                                      // DELETE
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),

                                        onPressed: () {
                                          showDialog(
                                            context: context,

                                            builder: (_) => AlertDialog(
                                              title: const Text(
                                                "Hapus Perusahaan",
                                              ),

                                              content: Text(
                                                "Yakin ingin menghapus ${company.companyName} ?",
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },

                                                  child: const Text("Batal"),
                                                ),

                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await context
                                                        .read<CompanyProvider>()
                                                        .deleteCompany(
                                                          company.id,
                                                        );

                                                    if (!mounted) return;

                                                    Navigator.of(context).pop();

                                                    ScaffoldMessenger.of(
                                                      this.context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Perusahaan berhasil dihapus",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Hapus"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();

    super.dispose();
  }

  void showCreateDialog() {
    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Perusahaan"),

          content: SizedBox(
            width: 450,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: namaController,

                    decoration: const InputDecoration(
                      labelText: "Nama Perusahaan",
                    ),
                  ),

                  TextField(
                    controller: alamatController,

                    decoration: const InputDecoration(labelText: "Alamat"),
                  ),

                  TextField(
                    controller: emailController,

                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  TextField(
                    controller: phoneController,

                    decoration: const InputDecoration(labelText: "Phone"),
                  ),

                  TextField(
                    controller: websiteController,

                    decoration: const InputDecoration(labelText: "Website"),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () async {
                await context.read<CompanyProvider>().createCompany(
                  namaPerusahaan: namaController.text,

                  alamat: alamatController.text,

                  email: emailController.text,

                  phone: phoneController.text,

                  website: websiteController.text,
                );

                namaController.clear();
                alamatController.clear();
                emailController.clear();
                phoneController.clear();
                websiteController.clear();

                Navigator.pop(context);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Perusahaan berhasil ditambahkan"),
                    ),
                  );
                }
              },

              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(company) {
    namaController.text = company.companyName;

    alamatController.text = company.alamat;

    emailController.text = company.email;

    phoneController.text = company.telepon;

    websiteController.text = company.website;

    showDialog(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Perusahaan"),

          content: SizedBox(
            width: 450,

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  TextField(
                    controller: namaController,

                    decoration: const InputDecoration(
                      labelText: "Nama Perusahaan",
                    ),
                  ),

                  TextField(
                    controller: alamatController,

                    decoration: const InputDecoration(labelText: "Alamat"),
                  ),

                  TextField(
                    controller: emailController,

                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  TextField(
                    controller: phoneController,

                    decoration: const InputDecoration(labelText: "Phone"),
                  ),

                  TextField(
                    controller: websiteController,

                    decoration: const InputDecoration(labelText: "Website"),
                  ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () async {
                await context.read<CompanyProvider>().updateCompany(
                  companyId: company.id,

                  namaPerusahaan: namaController.text,

                  alamat: alamatController.text,

                  email: emailController.text,

                  phone: phoneController.text,

                  website: websiteController.text,
                );

                namaController.clear();
                alamatController.clear();
                emailController.clear();
                phoneController.clear();
                websiteController.clear();

                if (mounted) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Perusahaan berhasil diupdate"),
                    ),
                  );
                }
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
