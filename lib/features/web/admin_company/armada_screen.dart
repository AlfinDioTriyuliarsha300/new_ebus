import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/bus_provider.dart';
import 'widgets/sidebar.dart';

class ArmadaScreen extends StatefulWidget {
  const ArmadaScreen({super.key});

  @override
  State<ArmadaScreen> createState() => _ArmadaScreenState();
}

class _ArmadaScreenState extends State<ArmadaScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<BusProvider>().getBuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 1,
            onMenuSelected: (menu) {
              switch (menu) {
                case 0:
                  context.go("/admin-company");
                  break;

                case 1:
                  context.go("/armada");
                  break;

                case 2:
                  context.go("/route");
                  break;

                case 3:
                  context.go("/schedule");
                  break;

                case 4:
                  context.go("/driver");
                  break;

                case 5:
                  context.go("/monitoring");
                  break;

                case 6:
                  context.go("/report");
                  break;

                case 7:
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

              child: Consumer<BusProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Manajemen Armada",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () {
                          final nomorController = TextEditingController();

                          final platController = TextEditingController();

                          final statusController = TextEditingController(
                            text: "Aktif",
                          );

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text("Tambah Armada"),

                                content: SizedBox(
                                  width: 400,

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      TextField(
                                        controller: nomorController,
                                        decoration: const InputDecoration(
                                          labelText: "Nomor Bus",
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      TextField(
                                        controller: platController,
                                        decoration: const InputDecoration(
                                          labelText: "Plat Nomor",
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      TextField(
                                        controller: statusController,
                                        decoration: const InputDecoration(
                                          labelText: "Status",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text("Batal"),
                                  ),

                                  ElevatedButton(
                                    onPressed: () async {
                                      await provider.addBus(
                                        companyId: 2,
                                        nomorBus: nomorController.text,
                                        platNomor: platController.text,
                                        status: statusController.text,
                                      );

                                      if (!context.mounted) return;

                                      Navigator.pop(dialogContext);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Armada berhasil ditambahkan",
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Simpan"),
                                  ),
                                ],
                              );
                            },
                          );
                        },

                        icon: const Icon(Icons.add),

                        label: const Text("Tambah Armada"),
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          elevation: 3,
                          child: SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 350,
                                ),

                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text("ID")),

                                    DataColumn(label: Text("Nomor Bus")),

                                    DataColumn(label: Text("Plat Nomor")),

                                    DataColumn(label: Text("Status")),

                                    DataColumn(label: Text("Tracking")),

                                    DataColumn(label: Text("Aksi")),
                                  ],

                                  rows: provider.buses.map((bus) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(bus.id.toString())),

                                        DataCell(Text(bus.nomorBus)),

                                        DataCell(Text(bus.platNomor)),

                                        DataCell(Text(bus.status)),

                                        DataCell(
                                          Text(
                                            bus.isTracking ? "Aktif" : "Tidak",
                                          ),
                                        ),

                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      final nomorController =
                                                          TextEditingController(
                                                            text: bus.nomorBus,
                                                          );

                                                      final platController =
                                                          TextEditingController(
                                                            text: bus.platNomor,
                                                          );

                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Edit Armada",
                                                        ),

                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextField(
                                                              controller:
                                                                  nomorController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                        "Nomor Bus",
                                                                  ),
                                                            ),

                                                            const SizedBox(
                                                              height: 10,
                                                            ),

                                                            TextField(
                                                              controller:
                                                                  platController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                        "Plat Nomor",
                                                                  ),
                                                            ),
                                                          ],
                                                        ),

                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: const Text(
                                                              "Batal",
                                                            ),
                                                          ),

                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              await provider.editBus(
                                                                id: bus.id,
                                                                nomorBus:
                                                                    nomorController
                                                                        .text,
                                                                platNomor:
                                                                    platController
                                                                        .text,
                                                                status:
                                                                    bus.status,
                                                              );

                                                              if (!mounted)
                                                                return;

                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: const Text(
                                                              "Simpan",
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                        context: context,
                                                        builder: (_) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              "Hapus Armada",
                                                            ),
                                                            content: Text(
                                                              "Yakin hapus bus ${bus.nomorBus} ?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                    false,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Batal",
                                                                    ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                    true,
                                                                  );
                                                                },
                                                                child:
                                                                    const Text(
                                                                      "Hapus",
                                                                    ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );

                                                  if (confirm == true) {
                                                    await provider.removeBus(
                                                      bus.id,
                                                    );

                                                    if (!mounted) return;

                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Armada berhasil dihapus",
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
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
