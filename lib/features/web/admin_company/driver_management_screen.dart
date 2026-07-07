import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_ebus/features/web/admin_company/widgets/sidebar.dart';
import 'package:new_ebus/providers/driver_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() =>
      _DriverManagementScreenState();
}

class _DriverManagementScreenState
    extends State<DriverManagementScreen> {

  int companyId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      final prefs =
          await SharedPreferences.getInstance();

      companyId =
          prefs.getInt("company_id") ?? 0;

      if (!mounted) return;

      await context
          .read<DriverProvider>()
          .getDrivers(companyId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(

        children: [

          AdminSidebar(

            selectedMenu: 5,

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

            child: Padding(

              padding: const EdgeInsets.all(24),

              child: Consumer<DriverProvider>(

                builder: (context, provider, child) {

                  if (provider.isLoading) {

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        "Manajemen Driver",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(

                        icon: const Icon(Icons.add),

                        label:
                            const Text("Tambah Driver"),

                        onPressed: () {

                          final namaController =
                              TextEditingController();

                          final kontakController =
                              TextEditingController();

                          showDialog(

                            context: context,

                            builder: (dialogContext) {

                              return AlertDialog(

                                title:
                                    const Text("Tambah Driver"),

                                content: SizedBox(

                                  width: 400,

                                  child: Column(

                                    mainAxisSize:
                                        MainAxisSize.min,

                                    children: [

                                      TextField(
                                        controller:
                                            namaController,

                                        decoration:
                                            const InputDecoration(
                                          labelText:
                                              "Nama Driver",
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      TextField(
                                        controller:
                                            kontakController,

                                        decoration:
                                            const InputDecoration(
                                          labelText:
                                              "Kontak",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {
                                      Navigator.pop(
                                          dialogContext);
                                    },

                                    child:
                                        const Text("Batal"),
                                  ),

                                  ElevatedButton(

                                    onPressed: () async {

                                      await provider
                                          .createDriver(

                                        companyId:
                                            companyId,

                                        nama:
                                            namaController.text,

                                        kontak:
                                            kontakController.text,
                                      );

                                      if (!mounted) return;

                                      Navigator.pop(
                                          dialogContext);
                                    },

                                    child:
                                        const Text("Simpan"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Expanded(

                        child: Card(

                          child: ListView.builder(

                            itemCount:
                                provider.drivers.length,

                            itemBuilder: (context, index) {

                              final driver =
                                  provider.drivers[index];

                              return ListTile(

                                leading: const Icon(
                                  Icons.person,
                                ),

                                title:
                                    Text(driver.driverName),

                                subtitle: Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(
                                      "Kontak : ${driver.kontak}",
                                    ),

                                    Text(
                                      "Status : ${driver.status}",
                                    ),
                                  ],
                                ),

                                trailing: Row(

                                  mainAxisSize:
                                      MainAxisSize.min,

                                  children: [

                                    IconButton(

                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),

                                      onPressed: () {

                                        final namaController =
                                            TextEditingController(
                                          text:
                                              driver.driverName,
                                        );

                                        final kontakController =
                                            TextEditingController(
                                          text:
                                              driver.kontak,
                                        );

                                        String status =
                                            driver.status;

                                        showDialog(

                                          context: context,

                                          builder:
                                              (dialogContext) {

                                            return AlertDialog(

                                              title:
                                                  const Text(
                                                      "Edit Driver"),

                                              content:
                                                  StatefulBuilder(

                                                builder:
                                                    (context,
                                                        setState) {

                                                  return SizedBox(

                                                    width: 400,

                                                    child: Column(

                                                      mainAxisSize:
                                                          MainAxisSize.min,

                                                      children: [

                                                        TextField(
                                                          controller:
                                                              namaController,

                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Nama Driver",
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                            height: 10),

                                                        TextField(
                                                          controller:
                                                              kontakController,

                                                          decoration:
                                                              const InputDecoration(
                                                            labelText:
                                                                "Kontak",
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                            height: 10),

                                                        DropdownButtonFormField<String>(

                                                          value: status,

                                                          items: const [

                                                            DropdownMenuItem(
                                                              value:
                                                                  "Tersedia",

                                                              child:
                                                                  Text("Tersedia"),
                                                            ),

                                                            DropdownMenuItem(
                                                              value:
                                                                  "Bertugas",

                                                              child:
                                                                  Text("Bertugas"),
                                                            ),

                                                            DropdownMenuItem(
                                                              value:
                                                                  "Tidak Aktif",

                                                              child:
                                                                  Text("Tidak Aktif"),
                                                            ),
                                                          ],

                                                          onChanged:
                                                              (v) {

                                                            setState(() {
                                                              status =
                                                                  v!;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),

                                              actions: [

                                                TextButton(

                                                  onPressed: () {
                                                    Navigator.pop(
                                                        dialogContext);
                                                  },

                                                  child:
                                                      const Text("Batal"),
                                                ),

                                                ElevatedButton(

                                                  onPressed: () async {

                                                    await provider
                                                        .updateDriver(

                                                      id: driver.id,

                                                      companyId:
                                                          companyId,

                                                      nama:
                                                          namaController.text,

                                                      kontak:
                                                          kontakController.text,

                                                      status:
                                                          status,
                                                    );

                                                    if (!mounted) return;

                                                    Navigator.pop(
                                                        dialogContext);
                                                  },

                                                  child:
                                                      const Text("Update"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),

                                    IconButton(

                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),

                                      onPressed: () async {

                                        await provider
                                            .deleteDriver(
                                          driver.id,
                                          companyId,
                                        );
                                      },
                                    ),
                                  ],
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
}