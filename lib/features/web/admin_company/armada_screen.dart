import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/bus_provider.dart';
import '../../../providers/driver_provider.dart';
import '../../../providers/mesin_provider.dart';
import '../../../providers/route_provider.dart';
import '../../../providers/schedule_provider.dart';

import 'widgets/sidebar.dart';

class ArmadaScreen extends StatefulWidget {
  final int companyId;

  const ArmadaScreen({super.key, required this.companyId});

  @override
  State<ArmadaScreen> createState() => _ArmadaScreenState();
}

class _ArmadaScreenState extends State<ArmadaScreen> {
  bool isPlatDuplicate(String plat, BusProvider provider, int currentBusId) {
    return provider.buses.any(
      (bus) =>
          bus.platNomor.toLowerCase() == plat.toLowerCase() &&
          bus.id != currentBusId,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();

      final companyId =
          prefs.getInt('company_id') ?? 0;

      await context.read<BusProvider>().getBuses();

      await context.read<DriverProvider>().getDrivers(
        companyId,
      );

      await context.read<MesinProvider>().getMesin();

      await context.read<RouteProvider>().getRoutes(
        companyId,
      );

      await context.read<ScheduleProvider>().getSchedules(
        companyId,
      );

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

                          int? selectedDriverId;
                          int? selectedMesinId;
                          int? selectedRouteId;
                          int? selectedScheduleId;

                          String status = "Aktif";

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text("Tambah Armada"),

                                content: SizedBox(
                                  width: 450,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownButtonFormField<int>(
                                          value: selectedDriverId,
                                          decoration: const InputDecoration(
                                            labelText: "Driver",
                                            border: OutlineInputBorder(),
                                          ),
                                          items: context
                                              .read<DriverProvider>()
                                              .drivers
                                              .map((driver) {
                                                return DropdownMenuItem(
                                                  value: driver.id,
                                                  child: Text(
                                                    driver.driverName,
                                                  ),
                                                );
                                              })
                                              .toList(),
                                          onChanged: (value) {
                                            selectedDriverId = value;
                                          },
                                        ),

                                        TextFormField(
                                          controller: nomorController,
                                          decoration: InputDecoration(
                                            labelText: "Nomor Bus",
                                            prefixIcon: Icon(
                                              Icons.confirmation_number,
                                            ),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                          controller: platController,
                                          decoration: InputDecoration(
                                            labelText: "Plat Nomor",
                                            prefixIcon: Icon(Icons.pin),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        DropdownButtonFormField<String>(
                                          initialValue: status,
                                          decoration: InputDecoration(
                                            labelText: "Status Armada",
                                            prefixIcon: Icon(Icons.verified),
                                            border: OutlineInputBorder(),
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: "Aktif",
                                              child: Text("🟢 Aktif"),
                                            ),

                                            DropdownMenuItem(
                                              value: "Non Aktif",
                                              child: Text("⚫ Non Aktif"),
                                            ),

                                            DropdownMenuItem(
                                              value: "Tidak Ada Driver",
                                              child: Text("🔴 Tidak Ada Driver"),
                                            ),

                                            DropdownMenuItem(
                                              value: "Maintenance",
                                              child: Text("🟠 Maintenance"),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            status = value!;
                                          },
                                        ),

                                        const SizedBox(height: 10),

                                        DropdownButtonFormField<int>(
                                          value: selectedMesinId,
                                          decoration: const InputDecoration(
                                            labelText: "Mesin",
                                            border: OutlineInputBorder(),
                                          ),
                                          items: context
                                              .read<MesinProvider>()
                                              .mesinList
                                              .map((mesin) {
                                                return DropdownMenuItem(
                                                  value: mesin.id,
                                                  child: Text(mesin.namaMesin),
                                                );
                                              })
                                              .toList(),
                                          onChanged: (value) {
                                            selectedMesinId = value;
                                          },
                                        ),

                                        const SizedBox(height: 10),

                                        DropdownButtonFormField<int>(
                                          value: selectedRouteId,
                                          decoration: const InputDecoration(
                                            labelText: "Route",
                                            border: OutlineInputBorder(),
                                          ),
                                          items: context
                                              .read<RouteProvider>()
                                              .routes
                                              .map((route) {
                                                return DropdownMenuItem(
                                                  value: route.id,
                                                  child: Text(route.namaRute),
                                                );
                                              })
                                              .toList(),
                                          onChanged: (value) {
                                            selectedRouteId = value;
                                          },
                                        ),

                                        const SizedBox(height: 10),

                                        DropdownButtonFormField<int>(
                                          value: selectedScheduleId,
                                          decoration: const InputDecoration(
                                            labelText: "Schedule",
                                            border: OutlineInputBorder(),
                                          ),
                                          items: context
                                              .read<ScheduleProvider>()
                                              .schedules
                                              .map((schedule) {
                                                return DropdownMenuItem(
                                                  value: schedule.id,
                                                  child: Text(
                                                    schedule.jamBerangkat,
                                                  ),
                                                );
                                              })
                                              .toList(),
                                          onChanged: (value) {
                                            selectedScheduleId = value;
                                          },
                                        ),

                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),

                                actions: [
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.close),

                                    label: const Text("Batal"),

                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),

                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                  ),

                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.save),
                                    label: const Text("Simpan"),
                                    onPressed: () async {
                                      if (nomorController.text.isEmpty ||
                                          platController.text.isEmpty ||
                                          selectedDriverId == null ||
                                          selectedMesinId == null ||
                                          selectedRouteId == null ||
                                          selectedScheduleId == null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Semua data armada wajib diisi",
                                            ),
                                          ),
                                        );

                                        return;
                                      }

                                      final duplicate = provider.buses.any(
                                      (b) =>
                                          b.platNomor.toLowerCase() ==
                                          platController.text.trim().toLowerCase(),
                                    );

                                    if (duplicate) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Plat nomor sudah digunakan",
                                          ),
                                        ),
                                      );

                                      return;
                                    }

                                      await provider.addBus(
                                        companyId: widget.companyId,

                                        driverId: selectedDriverId,

                                        nomorBus: nomorController.text.trim(),

                                        platNomor: platController.text.trim(),

                                        mesinId: selectedMesinId!,

                                        routeId: selectedRouteId,

                                        scheduleId: selectedScheduleId,

                                        status: status,
                                      );
                                      await provider.getBuses();

                                      if (!dialogContext.mounted) return;

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
                                    DataColumn(label: Text("Driver")),
                                    DataColumn(label: Text("Mesin")),
                                    DataColumn(label: Text("Route")),
                                    DataColumn(label: Text("Schedule")),
                                    DataColumn(label: Text("Status")),
                                    DataColumn(label: Text("Tracking")),
                                    DataColumn(label: Text("Aksi")),
                                  ],

                                  rows: provider.buses.map((bus) {
                                    final mesin = context
                                        .read<MesinProvider>()
                                        .mesinList
                                        .where((m) => m.id == bus.mesinId)
                                        .firstOrNull;

                                    final driver = context
                                        .read<DriverProvider>()
                                        .drivers
                                        .where((d) => d.id == bus.driverId)
                                        .firstOrNull;

                                    final route = context
                                        .read<RouteProvider>()
                                        .routes
                                        .where((r) => r.id == bus.routeId)
                                        .firstOrNull;

                                    final schedule = context
                                        .read<ScheduleProvider>()
                                        .schedules
                                        .where((s) => s.id == bus.scheduleId)
                                        .firstOrNull;

                                    return DataRow(
                                      cells: [
                                        DataCell(Text(bus.id.toString())),

                                        DataCell(Text(bus.nomorBus)),

                                        DataCell(Text(bus.platNomor)),

                                        DataCell(
                                          Text(driver?.driverName ?? "-"),
                                        ),

                                        DataCell(Text(mesin?.namaMesin ?? "-")),

                                        DataCell(Text(route?.namaRute ?? "-")),

                                        DataCell(
                                          Text(schedule?.jamBerangkat ?? "-"),
                                        ),

                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),

                                            decoration: BoxDecoration(
                                              color: bus.status == "Aktif"
                                                  ? Colors.green.shade100
                                                  : bus.status == "Maintenance"
                                                      ? Colors.orange.shade100
                                                      : bus.status == "Tidak Ada Driver"
                                                          ? Colors.red.shade100
                                                          : Colors.grey.shade300,

                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),

                                            child: Text(
                                              bus.status,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: bus.status == "Aktif"
                                                    ? Colors.green
                                                    : bus.status == "Maintenance"
                                                        ? Colors.orange
                                                        : bus.status == "Tidak Ada Driver"
                                                            ? Colors.red
                                                            : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),

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

                                                      int? editDriverId =
                                                          bus.driverId;
                                                      int? editMesinId =
                                                          bus.mesinId;
                                                      int? editRouteId =
                                                          bus.routeId;
                                                      int? editScheduleId =
                                                          bus.scheduleId;

                                                      String editStatus =
                                                          bus.status;

                                                      return AlertDialog(
                                                        title: const Text(
                                                          "Edit Armada",
                                                        ),

                                                        content: SizedBox(
                                                          width: 450,
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                DropdownButtonFormField<
                                                                  int
                                                                >(
                                                                  initialValue:
                                                                      editDriverId,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                        labelText:
                                                                            "Driver",
                                                                      ),
                                                                  items: context
                                                                      .read<
                                                                        DriverProvider
                                                                      >()
                                                                      .drivers
                                                                      .map((
                                                                        driver,
                                                                      ) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              driver.id,
                                                                          child: Text(
                                                                            driver.driverName,
                                                                          ),
                                                                        );
                                                                      })
                                                                      .toList(),
                                                                  onChanged: (value) {
                                                                    editDriverId =
                                                                        value;
                                                                  },
                                                                ),

                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

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

                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                DropdownButtonFormField<
                                                                  int
                                                                >(
                                                                  initialValue:
                                                                      editMesinId,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                        labelText:
                                                                            "Mesin",
                                                                      ),
                                                                  items: context
                                                                      .read<
                                                                        MesinProvider
                                                                      >()
                                                                      .mesinList
                                                                      .map((
                                                                        mesin,
                                                                      ) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              mesin.id,
                                                                          child: Text(
                                                                            mesin.namaMesin,
                                                                          ),
                                                                        );
                                                                      })
                                                                      .toList(),
                                                                  onChanged: (value) {
                                                                    editMesinId =
                                                                        value;
                                                                  },
                                                                ),

                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                DropdownButtonFormField<
                                                                  int
                                                                >(
                                                                  initialValue:
                                                                      editRouteId,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                        labelText:
                                                                            "Route",
                                                                      ),
                                                                  items: context
                                                                      .read<
                                                                        RouteProvider
                                                                      >()
                                                                      .routes
                                                                      .map((
                                                                        route,
                                                                      ) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              route.id,
                                                                          child: Text(
                                                                            route.namaRute,
                                                                          ),
                                                                        );
                                                                      })
                                                                      .toList(),
                                                                  onChanged: (value) {
                                                                    editRouteId =
                                                                        value;
                                                                  },
                                                                ),

                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                DropdownButtonFormField<
                                                                  int
                                                                >(
                                                                  initialValue:
                                                                      editScheduleId,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                        labelText:
                                                                            "Schedule",
                                                                      ),
                                                                  items: context
                                                                      .read<
                                                                        ScheduleProvider
                                                                      >()
                                                                      .schedules
                                                                      .map((
                                                                        schedule,
                                                                      ) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              schedule.id,
                                                                          child: Text(
                                                                            schedule.jamBerangkat,
                                                                          ),
                                                                        );
                                                                      })
                                                                      .toList(),
                                                                  onChanged: (value) {
                                                                    editScheduleId =
                                                                        value;
                                                                  },
                                                                ),

                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                DropdownButtonFormField<
                                                                  String
                                                                >(
                                                                  initialValue:
                                                                      editStatus,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                        labelText:
                                                                            "Status",
                                                                      ),
                                                                  items: const [
                                                                    DropdownMenuItem(
                                                                      value: "Aktif",
                                                                      child: Text("🟢 Aktif"),
                                                                    ),

                                                                    DropdownMenuItem(
                                                                      value: "Non Aktif",
                                                                      child: Text("⚫ Non Aktif"),
                                                                    ),

                                                                    DropdownMenuItem(
                                                                      value: "Tidak Ada Driver",
                                                                      child: Text("🔴 Tidak Ada Driver"),
                                                                    ),

                                                                    DropdownMenuItem(
                                                                      value: "Maintenance",
                                                                      child: Text("🟠 Maintenance"),
                                                                    ),
                                                                  ],
                                                                  onChanged: (value) {
                                                                    editStatus =
                                                                        value!;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
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
                                                              if (nomorController
                                                                      .text
                                                                      .trim()
                                                                      .isEmpty ||
                                                                  platController
                                                                      .text
                                                                      .trim()
                                                                      .isEmpty ||
                                                                  editDriverId ==
                                                                      null ||
                                                                  editMesinId ==
                                                                      null ||
                                                                  editRouteId ==
                                                                      null ||
                                                                  editScheduleId ==
                                                                      null) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      "Semua data armada wajib diisi",
                                                                    ),
                                                                  ),
                                                                );

                                                                return;
                                                              }

                                                              final duplicate = provider.buses.any(
                                                                (b) =>
                                                                    b.platNomor
                                                                        .toLowerCase() ==
                                                                    platController
                                                                        .text
                                                                        .trim()
                                                                        .toLowerCase(),
                                                              );

                                                              if (
                                                                isPlatDuplicate(
                                                                  platController.text,
                                                                  provider,
                                                                  bus.id,
                                                                )
                                                              )
                                                              {
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      "Plat nomor sudah digunakan",
                                                                    ),
                                                                  ),
                                                                );

                                                                return;
                                                              }

                                                              await provider.editBus(
                                                                id: bus.id,
                                                                companyId: bus
                                                                    .companyId,
                                                                driverId:
                                                                    editDriverId,
                                                                nomorBus:
                                                                    nomorController
                                                                        .text
                                                                        .trim(),
                                                                platNomor:
                                                                    platController
                                                                        .text
                                                                        .trim(),
                                                                mesinId:
                                                                    editMesinId!,
                                                                routeId:
                                                                    editRouteId,
                                                                scheduleId:
                                                                    editScheduleId,
                                                                status:
                                                                    editStatus,
                                                              );
                                                              await provider.getBuses();

                                                              if (!context
                                                                  .mounted)
                                                                return;

                                                              Navigator.pop(
                                                                context,
                                                              );

                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    "Armada berhasil diperbarui",
                                                                  ),
                                                                ),
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
