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
  late PassengerTrackingProvider trackingProvider;

  String? _lastGeofenceMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackingProvider = context.read<PassengerTrackingProvider>();

      trackingProvider.startRealtime(widget.ticket);
    });
  }

  void _listenGeofenceEvent(PassengerTrackingProvider provider) {
    final message = provider.latestGeofenceMessage;

    if (message == null) {
      return;
    }

    if (message == _lastGeofenceMessage) {
      return;
    }

    _lastGeofenceMessage = message;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final split = message.split(":");

      if (split.length < 2) return;

      final status = split.first.toLowerCase();

      final zone = split.sublist(1).join(":");

      late Color color;
      late IconData icon;
      late String text;

      switch (status) {
        case "enter":
          color = Colors.green;
          icon = Icons.login;
          text = "Bus memasuki $zone";
          break;

        case "inside":
          color = Colors.blue;
          icon = Icons.location_on;
          text = "Bus berada di $zone";
          break;

        case "exit":
          color = Colors.red;
          icon = Icons.logout;
          text = "Bus keluar dari $zone";
          break;

        case "arrived":
          color = Colors.purple;
          icon = Icons.flag;
          text = "Bus telah tiba di $zone";
          break;

        default:
          color = Colors.grey;
          icon = Icons.info;
          text = zone;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: color,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Row(
              children: [
                Icon(icon, color: Colors.white),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PassengerTrackingProvider>();

    _listenGeofenceEvent(provider);

    // ==========================
    // LOADING
    // ==========================
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ==========================
    // ERROR
    // ==========================
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

    // ==========================
    // TRACKING
    // ==========================
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Bus")),
      body: Stack(
        children: [
          Positioned.fill(child: PassengerTrackingMap(provider: provider)),

          Positioned(
            right: 16,
            bottom: 220,
            child: FloatingActionButton.small(
              heroTag: "follow_bus",
              onPressed: () {
                provider.enableFollowBus();
              },
              child: Icon(
                provider.followBus
                    ? Icons.my_location
                    : Icons.location_searching,
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.22,
            minChildSize: 0.18,
            maxChildSize: 0.65,
            snap: true,
            snapSizes: const [0.22, 0.40, 0.65],
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 12),

                      PassengerTrackingInfoCard(provider: provider),
                    ],
                  ),
                ),
              );
            },
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
    trackingProvider.stopRealtime();

    ScaffoldMessenger.of(context).clearSnackBars();

    super.dispose();
  }
}
