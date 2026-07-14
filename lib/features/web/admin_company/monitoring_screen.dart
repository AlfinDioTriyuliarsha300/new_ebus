import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:new_ebus/features/web/admin_company/widgets/sidebar.dart';
import 'package:new_ebus/providers/monitoring_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_ebus/models/route_model.dart';
import 'package:new_ebus/core/services/route_service.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  int companyId = 0;
  int? selectedBusId;

  Timer? _refreshTimer;

  RouteModel? selectedRoute;

  final RouteService routeService = RouteService();
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();

      companyId = prefs.getInt("company_id") ?? 0;

      if (!mounted) return;

      final provider = context.read<MonitoringProvider>();

      await provider.getLocations(companyId);

      provider.startRealtime(companyId);

      _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
        if (!mounted) return;

        await context.read<MonitoringProvider>().getLocations(
          companyId,
          refresh: true,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            selectedMenu: 6,

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

              child: Consumer<MonitoringProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (selectedBusId != null) {
                    final bus = provider.buses.firstWhere(
                      (e) => e.id == selectedBusId,
                    );

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      mapController.move(
                        LatLng(bus.latitude, bus.longitude),

                        mapController.camera.zoom,
                      );
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Monitoring Armada",

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: DropdownButton<int>(
                          value: selectedBusId,

                          hint: const Text("Pilih Bus"),

                          isExpanded: true,

                          underline: const SizedBox(),

                          items: provider.buses.map<DropdownMenuItem<int>>((
                            bus,
                          ) {
                            return DropdownMenuItem<int>(
                              value: bus.id,
                              child: Text(bus.platNomor),
                            );
                          }).toList(),

                          onChanged: (value) async {
                            setState(() {
                              selectedBusId = value;
                            });

                            if (value != null) {
                              selectedRoute = await routeService.getRouteBus(
                                value,
                              );

                              setState(() {});
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      Expanded(
                        child: Card(
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: const LatLng(-7.2575, 112.7521),

                              initialZoom: 11,
                            ),

                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',

                                userAgentPackageName: 'com.new_ebus.app',
                              ),

                              CircleLayer(
                                circles: [
                                  // Terminal Awal
                                  if (selectedRoute?.startLat != null)
                                    CircleMarker(
                                      point: LatLng(
                                        selectedRoute!.startLat!,
                                        selectedRoute!.startLng!,
                                      ),
                                      radius: 800,
                                      useRadiusInMeter: true,
                                      color: Colors.green.withOpacity(0.3),
                                      borderColor: Colors.green,
                                      borderStrokeWidth: 2,
                                    ),

                                  // Checkpoint A
                                  if (selectedRoute?.checkpointALat != null)
                                    CircleMarker(
                                      point: LatLng(
                                        selectedRoute!.checkpointALat!,
                                        selectedRoute!.checkpointALng!,
                                      ),
                                      radius: 500,
                                      useRadiusInMeter: true,
                                      color: Colors.orange.withOpacity(0.3),
                                      borderColor: Colors.orange,
                                      borderStrokeWidth: 2,
                                    ),

                                  // Checkpoint B
                                  if (selectedRoute?.checkpointBLat != null)
                                    CircleMarker(
                                      point: LatLng(
                                        selectedRoute!.checkpointBLat!,
                                        selectedRoute!.checkpointBLng!,
                                      ),
                                      radius: 500,
                                      useRadiusInMeter: true,
                                      color: Colors.purple.withOpacity(0.3),
                                      borderColor: Colors.purple,
                                      borderStrokeWidth: 2,
                                    ),

                                  // Terminal Tujuan
                                  if (selectedRoute?.endLat != null)
                                    CircleMarker(
                                      point: LatLng(
                                        selectedRoute!.endLat!,
                                        selectedRoute!.endLng!,
                                      ),
                                      radius: 800,
                                      useRadiusInMeter: true,
                                      color: Colors.red.withOpacity(0.3),
                                      borderColor: Colors.red,
                                      borderStrokeWidth: 2,
                                    ),
                                ],
                              ),

                              PolylineLayer(
                                polylines: [
                                  if (selectedRoute != null &&
                                      selectedRoute!.points.length >= 2)
                                    Polyline(
                                      points: selectedRoute!.points,
                                      strokeWidth: 6,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),

                              MarkerLayer(
                                markers: [
                                  // TERMINAL AWAL
                                  if (selectedRoute?.startLat != null)
                                    Marker(
                                      point: LatLng(
                                        selectedRoute!.startLat!,
                                        selectedRoute!.startLng!,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: const Tooltip(
                                        message: "Terminal Awal",
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.green,
                                          size: 45,
                                        ),
                                      ),
                                    ),

                                  // CHECKPOINT A
                                  if (selectedRoute?.checkpointALat != null)
                                    Marker(
                                      point: LatLng(
                                        selectedRoute!.checkpointALat!,
                                        selectedRoute!.checkpointALng!,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: const Tooltip(
                                        message: "Checkpoint A",
                                        child: Icon(
                                          Icons.flag,
                                          color: Colors.orange,
                                          size: 40,
                                        ),
                                      ),
                                    ),

                                  // CHECKPOINT B
                                  if (selectedRoute?.checkpointBLat != null)
                                    Marker(
                                      point: LatLng(
                                        selectedRoute!.checkpointBLat!,
                                        selectedRoute!.checkpointBLng!,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: const Tooltip(
                                        message: "Checkpoint B",
                                        child: Icon(
                                          Icons.flag,
                                          color: Colors.purple,
                                          size: 40,
                                        ),
                                      ),
                                    ),

                                  // TERMINAL TUJUAN
                                  if (selectedRoute?.endLat != null)
                                    Marker(
                                      point: LatLng(
                                        selectedRoute!.endLat!,
                                        selectedRoute!.endLng!,
                                      ),
                                      width: 50,
                                      height: 50,
                                      child: const Tooltip(
                                        message: "Terminal Tujuan",
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 45,
                                        ),
                                      ),
                                    ),

                                  // MARKER BUS
                                  ...provider.buses.map((bus) {
                                    return Marker(
                                      point: LatLng(
                                        bus.latitude,
                                        bus.longitude,
                                      ),

                                      child: Tooltip(
                                        message: bus.platNomor,

                                        child: Icon(
                                          Icons.directions_bus,

                                          size: 40,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
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
    _refreshTimer?.cancel();
    context.read<MonitoringProvider>().stopRealtime();
    super.dispose();
  }
}
