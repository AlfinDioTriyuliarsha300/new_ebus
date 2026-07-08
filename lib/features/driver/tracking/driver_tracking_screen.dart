import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../providers/driver_tracking_provider.dart';

import 'widgets/tracking_map.dart';
import 'widgets/tracking_info_card.dart';
import 'widgets/tracking_control_card.dart';
import 'widgets/tracking_status_chip.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key});

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  int? driverId;
  int? busId;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    driverId = prefs.getInt(StorageKeys.userId);

    busId = prefs.getInt("bus_id");

    if (busId != null) {

      print("BUS ID TRACKING = $busId");

      final provider =
          context.read<DriverTrackingProvider>();

      await provider.loadBusLocation(busId!);

      provider.startRealtime(busId!);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverTrackingProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(elevation: 0, title: const Text("Tracking Armada")),

      body: Column(
        children: [
          Expanded(flex: 5, child: TrackingMap(provider: provider)),

          Expanded(
            flex: 3,

            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  TrackingInfoCard(provider: provider),

                  const SizedBox(height: 15),

                  TrackingStatusChip(
                    tracking: provider.isTracking,

                    gpsActive: provider.currentPosition != null,
                  ),

                  const SizedBox(height: 15),

                  TrackingControlCard(provider: provider, driverId: driverId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
