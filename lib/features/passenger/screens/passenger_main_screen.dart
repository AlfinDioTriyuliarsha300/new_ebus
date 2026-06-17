import 'package:flutter/material.dart';

import 'passenger_history_screen.dart';
import 'passenger_home_screen.dart';
import 'passenger_setting_screen.dart';
import 'passenger_trip_screen.dart';

class PassengerMainScreen extends StatefulWidget {
  const PassengerMainScreen({super.key});

  @override
  State<PassengerMainScreen> createState() =>
      _PassengerMainScreenState();
}

class _PassengerMainScreenState
    extends State<PassengerMainScreen> {

  int currentIndex = 0;

  final pages = const [

    PassengerHomeScreen(),

    PassengerTripScreen(),

    PassengerHistoryScreen(),

    PassengerSettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (value) {

          setState(() {
            currentIndex = value;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: "Perjalanan",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Pengaturan",
          ),
        ],
      ),
    );
  }
}