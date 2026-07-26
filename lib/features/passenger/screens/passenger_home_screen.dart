import 'package:flutter/material.dart';

import 'widgets/passenger_header.dart';
import 'widgets/active_ticket_card.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Column(
          children: [
            const PassengerHeader(),

            Expanded(
              child: ListView(
                children: [
                  ActiveTicketCard(
                    onTracking: () {
                      // nanti diarahkan ke PassengerTrackingScreen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}