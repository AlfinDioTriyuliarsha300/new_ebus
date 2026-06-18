import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'providers/auth_provider.dart';
import 'providers/bus_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BusProvider(),
        ),

      ],

      child: const EBusApp(),
    ),
  );
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