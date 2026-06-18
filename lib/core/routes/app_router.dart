import 'package:go_router/go_router.dart';
import 'package:new_ebus/features/passenger/screens/passenger_main_screen.dart';
import 'package:new_ebus/features/web/admin_company/armada_screen.dart';

import '../../features/auth/splash_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/auth/forgot_password/forgot_password_screen.dart';
import '../../features/driver/screens/driver_main_screen.dart';
import '../../features/web/super_admin/super_admin_dashboard.dart';
import '../../features/web/admin_company/admin_company_dashboard.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/super-admin',
        builder: (context, state) => const SuperAdminDashboard(),
      ),

      GoRoute(
        path: '/admin-company',
        builder: (context, state) => const AdminCompanyDashboard(),
      ),

      GoRoute(
        path: '/driver-main',
        builder: (context, state) => const DriverMainScreen(),
      ),

      GoRoute(
        path: '/passenger-main',
        builder: (context, state) => const PassengerMainScreen(),
      ),

      GoRoute(
        path: '/armada',
        builder: (context, state) => const ArmadaScreen(),
      ),
    ],
  );
}
