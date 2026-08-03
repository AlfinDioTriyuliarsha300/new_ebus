import 'package:flutter/material.dart';

import 'package:new_ebus/providers/checkpoint_provider.dart';
import 'package:new_ebus/providers/company_provider.dart';
import 'package:new_ebus/providers/driver_dashboard_provider.dart';
import 'package:new_ebus/providers/driver_provider.dart';
import 'package:new_ebus/providers/mesin_provider.dart';
import 'package:new_ebus/providers/profile_provider.dart';
import 'package:new_ebus/providers/report_provider.dart';
import 'package:new_ebus/providers/route_provider.dart';
import 'package:new_ebus/providers/schedule_provider.dart';
import 'package:new_ebus/providers/terminal_provider.dart';
import 'package:new_ebus/providers/ticket_provider.dart';
import 'package:new_ebus/providers/user_provider.dart';
import 'package:new_ebus/providers/monitoring_provider.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:provider/provider.dart';
import 'providers/province_provider.dart';
import 'providers/city_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/bus_provider.dart';
import 'providers/driver_tracking_provider.dart';
import 'providers/passenger_tracking_provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/socket/socket_service.dart';
import 'core/services/firebase_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseService.instance.initialize();

  SocketService.connect();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => BusProvider()),

        ChangeNotifierProvider(create: (_) => DriverProvider()),

        ChangeNotifierProvider(create: (_) => MesinProvider()),

        ChangeNotifierProvider(create: (_) => RouteProvider()),

        ChangeNotifierProvider(create: (_) => ScheduleProvider()),

        ChangeNotifierProvider(create: (_) => TerminalProvider()),

        ChangeNotifierProvider(create: (_) => CheckpointProvider()),

        ChangeNotifierProvider(create: (_) => ProvinceProvider()),

        ChangeNotifierProvider(create: (_) => CityProvider()),

        ChangeNotifierProvider(create: (_) => MonitoringProvider()),

        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        ChangeNotifierProvider(create: (_) => CompanyProvider()),

        ChangeNotifierProvider(create: (_) => UserProvider()),

        ChangeNotifierProvider(create: (_) => ReportProvider()),

        ChangeNotifierProvider(create: (_) => DriverDashboardProvider()),

        ChangeNotifierProvider(create: (_) => DriverTrackingProvider()),

        ChangeNotifierProvider(create: (_) => PassengerTrackingProvider()),

        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],

      child: const EBusApp(),
    ),
  );
}

Future<void> initFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(alert: true, badge: true, sound: true);

  final token = await messaging.getToken();

  debugPrint("==============================");
  debugPrint("FCM TOKEN");
  debugPrint(token);
  debugPrint("==============================");
}

class EBusApp extends StatelessWidget {
  const EBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-Bus',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
