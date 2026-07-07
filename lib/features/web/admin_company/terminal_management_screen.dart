import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/province_model.dart';
import '../../../models/city_model.dart';
import '../../../models/terminal_model.dart';

import '../../../providers/province_provider.dart';
import '../../../providers/city_provider.dart';
import '../../../providers/terminal_provider.dart';

import 'widgets/sidebar.dart';

class TerminalManagementScreen extends StatefulWidget {
  const TerminalManagementScreen({super.key});

  @override
  State<TerminalManagementScreen> createState() =>
      _TerminalManagementScreenState();
}

class _TerminalManagementScreenState extends State<TerminalManagementScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProvinceProvider>().loadProvinces();

      await context.read<TerminalProvider>().loadTerminals();
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
              child: Consumer<TerminalProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Manajemen Terminal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: _showAddTerminalDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Terminal"),
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: ListView.builder(
                            itemCount: provider.terminals.length,

                            itemBuilder: (context, index) {
                              final terminal = provider.terminals[index];

                              return ListTile(
                                leading: const Icon(Icons.location_city),

                                title: Text(terminal.namaTerminal),

                                subtitle: Text(terminal.alamat),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _showEditTerminalDialog(terminal);
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await provider.deleteTerminal(
                                          terminal.id,
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

  void _showAddTerminalDialog() {
    final namaController = TextEditingController();

    final alamatController = TextEditingController();

    final latController = TextEditingController();

    final lngController = TextEditingController();

    ProvinceModel? selectedProvince;

    CityModel? selectedCity;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Tambah Terminal"),

              content: SizedBox(
                width: 500,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Consumer<ProvinceProvider>(
                        builder: (context, provinceProvider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            initialValue: selectedProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                            ),

                            items: provinceProvider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,

                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                selectedProvince = value;

                                selectedCity = null;
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
                        builder: (context, cityProvider, child) {
                          return DropdownButtonFormField<CityModel>(
                            initialValue: selectedCity,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                            ),

                            items: cityProvider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,

                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                selectedCity = value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: namaController,

                        decoration: const InputDecoration(
                          labelText: "Nama Terminal",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: alamatController,

                        decoration: const InputDecoration(labelText: "Alamat"),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: latController,

                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          labelText: "Latitude",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: lngController,

                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          labelText: "Longitude",
                        ),
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
                    if (selectedCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pilih Kota terlebih dahulu"),
                        ),
                      );

                      return;
                    }

                    await context.read<TerminalProvider>().createTerminal(
                      cityId: selectedCity!.id,

                      namaTerminal: namaController.text.trim(),

                      alamat: alamatController.text.trim(),

                      lat: double.tryParse(latController.text) ?? 0,

                      lng: double.tryParse(lngController.text) ?? 0,
                    );

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Terminal berhasil ditambahkan"),
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
    );
  }

  void _showEditTerminalDialog(TerminalModel terminal) {
    final namaController = TextEditingController(text: terminal.namaTerminal);

    final alamatController = TextEditingController(text: terminal.alamat);

    final latController = TextEditingController(text: terminal.lat.toString());

    final lngController = TextEditingController(text: terminal.lng.toString());

    ProvinceModel? selectedProvince;

    CityModel? selectedCity;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Terminal"),

              content: SizedBox(
                width: 500,

                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Consumer<ProvinceProvider>(
                        builder: (context, provinceProvider, child) {
                          return DropdownButtonFormField<ProvinceModel>(
                            initialValue: selectedProvince,

                            decoration: const InputDecoration(
                              labelText: "Pilih Provinsi",
                            ),

                            items: provinceProvider.provinces.map((province) {
                              return DropdownMenuItem(
                                value: province,

                                child: Text(province.namaProvinsi),
                              );
                            }).toList(),

                            onChanged: (value) async {
                              setDialogState(() {
                                selectedProvince = value;

                                selectedCity = null;
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
                        builder: (context, cityProvider, child) {
                          return DropdownButtonFormField<CityModel>(
                            initialValue: selectedCity,

                            decoration: const InputDecoration(
                              labelText: "Pilih Kota",
                            ),

                            items: cityProvider.startCities.map((city) {
                              return DropdownMenuItem(
                                value: city,

                                child: Text(city.namaKota),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setDialogState(() {
                                selectedCity = value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: namaController,

                        decoration: const InputDecoration(
                          labelText: "Nama Terminal",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: alamatController,

                        decoration: const InputDecoration(labelText: "Alamat"),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: latController,

                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          labelText: "Latitude",
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextFormField(
                        controller: lngController,

                        keyboardType: TextInputType.number,

                        decoration: const InputDecoration(
                          labelText: "Longitude",
                        ),
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
                    if (selectedCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Pilih Kota terlebih dahulu"),
                        ),
                      );

                      return;
                    }

                    await context.read<TerminalProvider>().updateTerminal(
                      id: terminal.id,

                      cityId: selectedCity!.id,

                      namaTerminal: namaController.text.trim(),

                      alamat: alamatController.text.trim(),

                      lat: double.tryParse(latController.text) ?? 0,

                      lng: double.tryParse(lngController.text) ?? 0,
                    );

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Terminal berhasil diperbarui"),
                      ),
                    );
                  },

                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
