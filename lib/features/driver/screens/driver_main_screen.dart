import 'package:flutter/material.dart';

import 'driver_history_screen.dart';
import 'driver_home_screen.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() =>
      _DriverMainScreenState();
}

class _DriverMainScreenState
    extends State<DriverMainScreen> {

  int currentIndex = 0;

  final pages = [
    const DriverHomeScreen(),
    const DriverHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {

          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histori',
          ),
        ],
      ),
    );
  }
}