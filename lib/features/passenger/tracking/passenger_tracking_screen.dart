import 'package:flutter/material.dart';
import 'package:new_ebus/features/passenger/tracking/widgets/passenger_info_card.dart';
import 'package:new_ebus/features/passenger/tracking/widgets/passenger_tracking_map.dart';
import 'package:provider/provider.dart';

import '../../../providers/passenger_tracking_provider.dart';

class PassengerTrackingScreen extends StatefulWidget {
  final int busId;
  final String ticket;

  const PassengerTrackingScreen({
    super.key,
    required this.ticket,
    required this.busId,
  });

  @override
  State<PassengerTrackingScreen> createState() =>
      _PassengerTrackingScreenState();
}

class _PassengerTrackingScreenState extends State<PassengerTrackingScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PassengerTrackingProvider>().startRealtime(widget.ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PassengerTrackingProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tracking Bus")),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 70),
                const SizedBox(height: 20),
                Text(provider.errorMessage!, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    provider.loadTracking(widget.ticket);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Coba Lagi"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Bus")),
      body: Column(
        children: [
          Expanded(
            child: PassengerTrackingMap(
              provider: provider,
            ),
          ),

          PassengerTrackingInfoCard(
            provider: provider,
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard(PassengerTrackingProvider provider) {
    final tracking = provider.trackingData;

    if (tracking == null) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoRow("Nomor Bus", tracking.bus.nomorBus),
          _buildInfoRow("Plat Nomor", tracking.bus.platNomor),
          _buildInfoRow("Status", tracking.bus.status),
          _buildInfoRow("Trayek", tracking.route?.nama ?? "-"),
          _buildInfoRow(
            "Kecepatan",
            "${tracking.location.speed.toStringAsFixed(1)} km/jam",
          ),
          _buildInfoRow(
            "Progress",
            "${tracking.location.progress.toStringAsFixed(0)} %",
          ),
          _buildInfoRow("Zona", tracking.location.currentZone ?? "-"),
          _buildInfoRow(
            "Status Zona",
            tracking.location.currentZoneStatus ?? "-",
          ),
          _buildInfoRow("Update Terakhir", tracking.location.updatedAt ?? "-"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(": "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    context.read<PassengerTrackingProvider>().stopRealtime();
    super.dispose();
  }
}
