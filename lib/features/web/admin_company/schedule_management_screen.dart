import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:new_ebus/features/web/admin_company/widgets/sidebar.dart';
import 'package:new_ebus/providers/bus_provider.dart';
import 'package:new_ebus/providers/schedule_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleManagementScreen extends StatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  State<ScheduleManagementScreen> createState() =>
      _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends State<ScheduleManagementScreen> {
  int companyId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      companyId = prefs.getInt('company_id') ?? 0;

      if (!mounted) return;

      // ambil armada terlebih dahulu
      await context.read<BusProvider>().getBuses();

      // ambil jadwal
      await context.read<ScheduleProvider>().getSchedules(companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 4,
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
              child: Consumer2<ScheduleProvider, BusProvider>(
                builder: (context, scheduleProvider, busProvider, child) {
                  if (scheduleProvider.isLoading || busProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Manajemen Jadwal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Jadwal"),
                        onPressed: () {
                          int? selectedBusId;
                          final tanggalController = TextEditingController();
                          final jamController = TextEditingController();
                          final hargaController = TextEditingController();
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text("Tambah Jadwal"),
                                    content: SizedBox(
                                      width: 450,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButtonFormField<int>(
                                            decoration: const InputDecoration(
                                              labelText: "No Plat",
                                            ),

                                            items: context
                                                .read<BusProvider>()
                                                .buses
                                                .map((bus) {
                                                  return DropdownMenuItem(
                                                    value: bus.id,

                                                    child: Text(bus.platNomor),
                                                  );
                                                })
                                                .toList(),

                                            onChanged: (v) {
                                              selectedBusId = v;
                                            },
                                          ),

                                          const SizedBox(height: 10),

                                          TextField(
                                            controller: tanggalController,
                                            readOnly: true,

                                            decoration: const InputDecoration(
                                              labelText: "Tanggal Berangkat",
                                              suffixIcon: Icon(Icons.calendar_today),
                                            ),

                                            onTap: () async {

                                              final DateTime? date =
                                                  await showDatePicker(

                                                context: context,

                                                initialDate: DateTime.now(),

                                                firstDate: DateTime.now(),

                                                lastDate: DateTime(2100),
                                              );

                                              if (date != null) {

                                                tanggalController.text =
                                                    DateFormat(
                                                      'yyyy-MM-dd',
                                                    ).format(date);
                                              }
                                            },
                                          ),

                                          const SizedBox(height: 10),

                                          TextField(
                                            controller: jamController,
                                            readOnly: true,

                                            decoration: const InputDecoration(
                                              labelText: "Jam Berangkat",
                                              suffixIcon: Icon(Icons.access_time),
                                            ),

                                            onTap: () async {

                                              final TimeOfDay? time =
                                                  await showTimePicker(

                                                context: context,

                                                initialTime: TimeOfDay.now(),
                                              );

                                              if (time != null) {

                                                final now = DateTime.now();

                                                final date = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                  time.hour,
                                                  time.minute,
                                                );

                                                jamController.text =
                                                    DateFormat(
                                                      'HH:mm:ss',
                                                    ).format(date);
                                              }
                                            },
                                          ),

                                          const SizedBox(height: 10),

                                          TextField(
                                            controller: hargaController,

                                            decoration: const InputDecoration(
                                              labelText: "Harga Tiket",
                                            ),
                                          ),
                                        ],
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
                                          if (selectedBusId == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Pilih armada terlebih dahulu",
                                                ),
                                              ),
                                            );

                                            return;
                                          }
                                          final bus = context
                                              .read<BusProvider>()
                                              .buses
                                              .firstWhere(
                                                (b) => b.id == selectedBusId,
                                              );

                                          print("BUS ID = ${bus.id}");
                                          print("ROUTE ID = ${bus.routeId}");
                                          print("COMPANY ID = $companyId");

                                          if (bus.routeId == null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Bus ini belum memiliki rute.",
                                                ),
                                              ),
                                            );

                                            return;
                                          }

                                          await scheduleProvider.createSchedule(
                                            companyId: companyId,

                                            busId: bus.id,

                                            routeId: bus.routeId!,

                                            tanggal: tanggalController.text,

                                            jam: jamController.text,

                                            harga: hargaController.text,
                                          );

                                          if (!mounted) return;

                                          Navigator.pop(context);
                                        },
                                        child: const Text("Simpan"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: ListView.builder(
                            itemCount: scheduleProvider.schedules.length,

                            itemBuilder: (context, index) {
                              final schedule =
                                  scheduleProvider.schedules[index];

                              return ListTile(
                                leading: const Icon(Icons.schedule),

                                title: Text(schedule.platNomor ?? "-"),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text("Rute : ${schedule.namaRute}"),

                                    Text(
                                      "Tanggal : ${schedule.tanggalBerangkat}",
                                    ),

                                    Text("Jam : ${schedule.jamBerangkat}"),

                                    Text("Harga : Rp ${schedule.hargaTiket}"),

                                    Text("Status : ${schedule.status}"),
                                  ],
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),

                                      onPressed: () {
                                        final tanggalController =
                                            TextEditingController(
                                              text: schedule.tanggalBerangkat,
                                            );

                                        final jamController =
                                            TextEditingController(
                                              text: schedule.jamBerangkat,
                                            );

                                        final hargaController =
                                            TextEditingController(
                                              text: schedule.hargaTiket,
                                            );

                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            int? selectedBusId = schedule.busId;
                                            return AlertDialog(
                                              title: const Text("Edit Jadwal"),
                                              content: SizedBox(
                                                width: 400,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    DropdownButtonFormField<
                                                      int
                                                    >(
                                                      value: selectedBusId,

                                                      decoration:
                                                          const InputDecoration(
                                                            labelText:
                                                                "No Plat",
                                                          ),

                                                      items: busProvider.buses.map((
                                                        bus,
                                                      ) {
                                                        return DropdownMenuItem(
                                                          value: bus.id,
                                                          child: Text(
                                                            bus.platNomor,
                                                          ),
                                                        );
                                                      }).toList(),

                                                      onChanged: (value) {
                                                        selectedBusId = value;
                                                      },
                                                    ),

                                                    const SizedBox(height: 10),

                                                    TextField(
                                                      controller: tanggalController,
                                                      readOnly: true,
                                                      decoration: const InputDecoration(
                                                        labelText: "Tanggal Berangkat",
                                                        suffixIcon: Icon(Icons.calendar_today),
                                                      ),
                                                      onTap: () async {
                                                        final date = await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime.now(),
                                                          firstDate: DateTime.now(),
                                                          lastDate: DateTime(2100),
                                                        );

                                                        if (date != null) {
                                                          tanggalController.text =
                                                              "${date.year.toString().padLeft(4, '0')}-"
                                                              "${date.month.toString().padLeft(2, '0')}-"
                                                              "${date.day.toString().padLeft(2, '0')}";
                                                        }
                                                      },
                                                    ),

                                                    const SizedBox(height: 10),

                                                    TextField(
                                                      controller: jamController,
                                                      readOnly: true,
                                                      decoration: const InputDecoration(
                                                        labelText: "Jam Berangkat",
                                                        suffixIcon: Icon(Icons.access_time),
                                                      ),
                                                      onTap: () async {
                                                        final time = await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay.now(),
                                                        );

                                                        if (time != null) {
                                                          jamController.text =
                                                              "${time.hour.toString().padLeft(2, '0')}:"
                                                              "${time.minute.toString().padLeft(2, '0')}:00";
                                                        }
                                                      },
                                                    ),

                                                    const SizedBox(height: 10),

                                                    TextField(
                                                      controller:
                                                          hargaController,

                                                      decoration:
                                                          const InputDecoration(
                                                            labelText: "Harga",
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(
                                                      dialogContext,
                                                    ).pop();
                                                  },
                                                  child: const Text("Batal"),
                                                ),

                                                ElevatedButton(
                                                  onPressed: () async {
                                                    if (selectedBusId == null) {
                                                      return;
                                                    }

                                                    final bus = busProvider
                                                        .buses
                                                        .firstWhere(
                                                          (e) =>
                                                              e.id ==
                                                              selectedBusId,
                                                        );

                                                    if (bus.routeId == null) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            "Bus belum memiliki rute",
                                                          ),
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    await scheduleProvider
                                                        .updateSchedule(
                                                          id: schedule.id,

                                                          companyId: companyId,

                                                          busId: bus.id,

                                                          routeId: bus.routeId!,

                                                          tanggal:
                                                              tanggalController
                                                                  .text,

                                                          jam: jamController
                                                              .text,

                                                          harga: hargaController
                                                              .text,
                                                        );

                                                    if (!mounted) return;

                                                    Navigator.of(
                                                      dialogContext,
                                                    ).pop();
                                                  },

                                                  child: const Text("Update"),
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
                                        final confirm = await showDialog<bool>(
                                          context: context,

                                          builder: (_) {
                                            return AlertDialog(
                                              title: const Text("Hapus Jadwal"),

                                              content: const Text(
                                                "Yakin ingin menghapus?",
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      false,
                                                    );
                                                  },

                                                  child: const Text("Tidak"),
                                                ),

                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  },

                                                  child: const Text("Ya"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          await scheduleProvider.deleteSchedule(
                                            schedule.id,
                                            companyId,
                                          );
                                        }
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
