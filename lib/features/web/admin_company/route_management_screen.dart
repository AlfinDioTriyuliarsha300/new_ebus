import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_ebus/features/web/admin_company/widgets/sidebar.dart';

import 'package:new_ebus/models/province_model.dart';
import 'package:new_ebus/models/city_model.dart';
import 'package:new_ebus/models/terminal_model.dart';
import 'package:new_ebus/models/route_model.dart';
import 'package:new_ebus/models/checkpoint_model.dart';

import 'package:new_ebus/providers/province_provider.dart';
import 'package:new_ebus/providers/city_provider.dart';
import 'package:new_ebus/providers/terminal_provider.dart';
import 'package:new_ebus/providers/route_provider.dart';
import 'package:new_ebus/providers/checkpoint_provider.dart';

class RouteManagementScreen extends StatefulWidget {
  const RouteManagementScreen({super.key});

  @override
  State<RouteManagementScreen> createState() => _RouteManagementScreenState();
}

class _RouteManagementScreenState extends State<RouteManagementScreen> {
  int companyId = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      companyId = prefs.getInt("company_id") ?? 0;

      if (!mounted) return;

      await context.read<ProvinceProvider>().loadProvinces();

      await context.read<TerminalProvider>().loadTerminals();

      await context.read<RouteProvider>().getRoutes(companyId);

      await context.read<CheckpointProvider>().loadCheckpoints();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 3,
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

              child: Consumer<RouteProvider>(
                builder: (context, routeProvider, child) {
                  if (routeProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Manajemen Rute",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),

                        label: const Text("Tambah Rute"),

                        onPressed: () {
                          _showAddDialog();
                        },
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: routeProvider.routes.isEmpty
                              ? const Center(child: Text("DATA ROUTE KOSONG"))
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,

                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text("ID")),

                                      DataColumn(label: Text("Nama Route")),

                                      DataColumn(label: Text("Awal")),

                                      DataColumn(label: Text("Tujuan")),

                                      DataColumn(label: Text("Aksi")),
                                    ],

                                    rows: routeProvider.routes.map((route) {
                                      final startTerminal = context
                                          .read<TerminalProvider>()
                                          .terminals
                                          .where(
                                            (e) =>
                                                e.id == route.startTerminalId,
                                          )
                                          .firstOrNull;

                                      final endTerminal = context
                                          .read<TerminalProvider>()
                                          .terminals
                                          .where(
                                            (e) => e.id == route.endTerminalId,
                                          )
                                          .firstOrNull;

                                      return DataRow(
                                        cells: [
                                          DataCell(Text(route.id.toString())),

                                          DataCell(Text(route.namaRute)),

                                          DataCell(
                                            Text(
                                              startTerminal?.namaTerminal ??
                                                  "-",
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              endTerminal?.namaTerminal ?? "-",
                                            ),
                                          ),

                                          DataCell(
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),

                                                  onPressed: () {
                                                    _showEditDialog(route);
                                                  },
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),

                                                  onPressed: () async {
                                                    await routeProvider
                                                        .deleteRoute(
                                                          route.id,
                                                          companyId,
                                                        );
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

  void _showAddDialog() {
    final namaController = TextEditingController();

    ProvinceModel? startProvince;
    ProvinceModel? endProvince;

    CityModel? startCity;
    CityModel? endCity;

    TerminalModel? startTerminal;
    TerminalModel? endTerminal;

    CheckpointModel? checkpointA;
    CheckpointModel? checkpointB;

    String routeMode = "tol";

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Route"),

          content: SizedBox(
            width: 700,

            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      /// ======================
                      /// KEBERANGKATAN
                      /// ======================
                      const Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          "KEBERANGKATAN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Consumer<ProvinceProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            value: startProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,

                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                startProvince = value;

                                startCity = null;

                                startTerminal = null;
                              });

                              if (value != null) {
                                await context
                                    .read<CityProvider>()
                                    .loadStartCities(value.id);
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      Consumer<CityProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<CityModel>(
                            value: provider.startCities.contains(startCity)
                                ? startCity
                                : null,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                startCity = value;
                                startTerminal = null;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<TerminalModel>(
                        value: startTerminal,

                        decoration: const InputDecoration(
                          labelText: "Terminal Keberangkatan",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<TerminalProvider>()
                            .terminals
                            .where(
                              (terminal) => terminal.cityId == startCity?.id,
                            )
                            .map((terminal) {
                              return DropdownMenuItem(
                                value: terminal,

                                child: Text(terminal.namaTerminal),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            startTerminal = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<CheckpointModel>(
                        value: checkpointA,

                        decoration: const InputDecoration(
                          labelText: "Checkpoint A",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<CheckpointProvider>()
                            .checkpoints
                            .map((checkpoint) {
                              return DropdownMenuItem(
                                value: checkpoint,
                                child: Text(checkpoint.nama),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            checkpointA = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<CheckpointModel>(
                        value: checkpointB,

                        decoration: const InputDecoration(
                          labelText: "Checkpoint B",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<CheckpointProvider>()
                            .checkpoints
                            .map((checkpoint) {
                              return DropdownMenuItem(
                                value: checkpoint,
                                child: Text(checkpoint.nama),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            checkpointB = value;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "TUJUAN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Consumer<ProvinceProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            value: endProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,
                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                endProvince = value;

                                endCity = null;

                                endTerminal = null;
                              });

                              if (value != null) {
                                await context
                                    .read<CityProvider>()
                                    .loadEndCities(value.id);
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      Consumer<CityProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<CityModel>(
                            value: provider.startCities.contains(endCity)
                                ? endCity
                                : null,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                endCity = value;
                                endTerminal = null;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<TerminalModel>(
                        value: endTerminal,

                        decoration: const InputDecoration(
                          labelText: "Terminal Tujuan",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<TerminalProvider>()
                            .terminals
                            .where((terminal) => terminal.cityId == endCity?.id)
                            .map((terminal) {
                              return DropdownMenuItem(
                                value: terminal,

                                child: Text(terminal.namaTerminal),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            endTerminal = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: routeMode,

                        decoration: const InputDecoration(
                          labelText: "Mode Perjalanan",
                          border: OutlineInputBorder(),
                        ),

                        items: const [
                          DropdownMenuItem(value: "tol", child: Text("Tol")),

                          DropdownMenuItem(
                            value: "non_tol",
                            child: Text("Non Tol"),
                          ),

                          DropdownMenuItem(
                            value: "campuran",
                            child: Text("Campuran"),
                          ),
                        ],

                        onChanged: (value) {
                          routeMode = value ?? "tol";
                        },
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: namaController,

                        decoration: const InputDecoration(
                          labelText: "Nama Rute",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
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
                if (startTerminal == null || endTerminal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Terminal keberangkatan dan tujuan wajib dipilih",
                      ),
                    ),
                  );

                  return;
                }

                if (namaController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama route wajib diisi")),
                  );

                  return;
                }

                await context.read<RouteProvider>().createRoute(
                  companyId: companyId,

                  namaRute: namaController.text.trim(),

                  startTerminal: startTerminal!,

                  endTerminal: endTerminal!,

                  checkpointAId: checkpointA?.id,

                  checkpointBId: checkpointB?.id,

                  routeMode: routeMode,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Route berhasil ditambahkan")),
                );
              },

              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(RouteModel route) {
    final namaController = TextEditingController(text: route.namaRute);

    ProvinceModel? startProvince;
    ProvinceModel? endProvince;

    CityModel? startCity;
    CityModel? endCity;

    TerminalModel? startTerminal;
    TerminalModel? endTerminal;

    CheckpointModel? checkpointA;
    CheckpointModel? checkpointB;

    String routeMode = "tol";

    final terminals = context.read<TerminalProvider>().terminals;

    startTerminal = terminals
        .where((t) => t.id == route.startTerminalId)
        .firstOrNull;

    endTerminal = terminals
        .where((t) => t.id == route.endTerminalId)
        .firstOrNull;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Route"),

          content: SizedBox(
            width: 600,

            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      TextField(
                        controller: namaController,

                        decoration: const InputDecoration(
                          labelText: "Nama Route",
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,

                        child: Text(
                          "KEBERANGKATAN",

                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Consumer<ProvinceProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            value: startProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,

                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                startProvince = value;

                                startCity = null;

                                startTerminal = null;
                              });

                              if (value != null) {
                                await context
                                    .read<CityProvider>()
                                    .loadStartCities(value.id);
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      Consumer<CityProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<CityModel>(
                            value: provider.startCities.contains(startCity)
                                ? startCity
                                : null,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                startCity = value;
                                startTerminal = null;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<TerminalModel>(
                        value: startTerminal,

                        decoration: const InputDecoration(
                          labelText: "Terminal Keberangkatan",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<TerminalProvider>()
                            .terminals
                            .where(
                              (terminal) => terminal.cityId == startCity?.id,
                            )
                            .map((terminal) {
                              return DropdownMenuItem(
                                value: terminal,

                                child: Text(terminal.namaTerminal),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            startTerminal = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<CheckpointModel>(
                        value: checkpointA,

                        decoration: const InputDecoration(
                          labelText: "Checkpoint A",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<CheckpointProvider>()
                            .checkpoints
                            .map((checkpoint) {
                              return DropdownMenuItem(
                                value: checkpoint,
                                child: Text(checkpoint.nama),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            checkpointA = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<CheckpointModel>(
                        value: checkpointB,

                        decoration: const InputDecoration(
                          labelText: "Checkpoint B",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<CheckpointProvider>()
                            .checkpoints
                            .map((checkpoint) {
                              return DropdownMenuItem(
                                value: checkpoint,
                                child: Text(checkpoint.nama),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            checkpointB = value;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "TUJUAN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Consumer<ProvinceProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            value: endProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,
                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                endProvince = value;

                                endCity = null;

                                endTerminal = null;
                              });

                              if (value != null) {
                                await context
                                    .read<CityProvider>()
                                    .loadEndCities(value.id);
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      Consumer<CityProvider>(
                        builder: (context, provider, child) {
                          return DropdownButtonFormField<CityModel>(
                            value: provider.startCities.contains(endCity)
                                ? endCity
                                : null,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                              border: OutlineInputBorder(),
                            ),

                            items: provider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                endCity = value;
                                endTerminal = null;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<TerminalModel>(
                        value: endTerminal,

                        decoration: const InputDecoration(
                          labelText: "Terminal Tujuan",
                          border: OutlineInputBorder(),
                        ),

                        items: context
                            .read<TerminalProvider>()
                            .terminals
                            .where((terminal) => terminal.cityId == endCity?.id)
                            .map((terminal) {
                              return DropdownMenuItem(
                                value: terminal,

                                child: Text(terminal.namaTerminal),
                              );
                            })
                            .toList(),

                        onChanged: (value) {
                          setDialogState(() {
                            endTerminal = value;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        initialValue: routeMode,

                        decoration: const InputDecoration(
                          labelText: "Mode Perjalanan",
                        ),

                        items: const [
                          DropdownMenuItem(value: "tol", child: Text("Tol")),

                          DropdownMenuItem(
                            value: "non_tol",
                            child: Text("Non Tol"),
                          ),

                          DropdownMenuItem(
                            value: "campuran",
                            child: Text("Campuran"),
                          ),
                        ],

                        onChanged: (value) {
                          routeMode = value ?? "tol";
                        },
                      ),
                    ],
                  ),
                );
              },
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
                if (startTerminal == null || endTerminal == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Terminal wajib dipilih")),
                  );

                  return;
                }

                await context.read<RouteProvider>().updateRoute(
                  id: route.id,
                  companyId: companyId,
                  namaRute: namaController.text.trim(),

                  startTerminal: startTerminal!,

                  endTerminal: endTerminal!,

                  checkpointAId: checkpointA?.id,

                  checkpointBId: checkpointB?.id,

                  routeMode: routeMode,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Route berhasil diperbarui")),
                );
              },

              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
