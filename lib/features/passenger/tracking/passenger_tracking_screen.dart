import 'package:flutter/material.dart';
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
      final provider = context.read<PassengerTrackingProvider>();

      provider.startRealtime(widget.ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PassengerTrackingProvider>();

    if (provider.isLoading) {
      return Scaffold(body: PassengerTrackingMap(provider: provider));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tracking Bus")),

      body: PassengerTrackingMap(provider: provider),
    );
  }

  @override
  void dispose() {
    context.read<PassengerTrackingProvider>().stopRealtime();

    super.dispose();
  }
}
