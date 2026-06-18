import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {

    final prefs =
        await SharedPreferences.getInstance();

    final isLoggedIn =
        prefs.getBool("is_logged_in") ?? false;

    final role =
        prefs.getString(
          StorageKeys.role,
        );

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    if (!isLoggedIn) {

      context.go("/login");

      return;
    }

    switch (role) {

      case "super_admin":
        context.go("/super-admin");
        break;

      case "admin_perusahaan":
        context.go("/admin-company");
        break;

      case "driver":
        context.go("/driver-main");
        break;

      case "penumpang":
        context.go("/passenger-main");
        break;

      default:
        context.go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}