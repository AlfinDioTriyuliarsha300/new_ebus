import 'package:go_router/go_router.dart';
import 'package:new_ebus/features/driver/home/driver_home_screen.dart';
import 'package:new_ebus/features/passenger/screens/passenger_main_screen.dart';
import 'package:new_ebus/features/passenger/tracking/passenger_tracking_input_screen.dart';
import 'package:new_ebus/features/passenger/tracking/passenger_tracking_screen.dart';
import 'package:new_ebus/features/web/admin_company/armada_screen.dart';
import 'package:new_ebus/features/web/admin_company/driver_management_screen.dart';
import 'package:new_ebus/features/web/admin_company/report/report_screen.dart';
import 'package:new_ebus/features/web/admin_company/route_management_screen.dart';
import 'package:new_ebus/features/web/admin_company/settings/settings_screen.dart';
import 'package:new_ebus/features/web/admin_company/terminal_management_screen.dart';
import 'package:new_ebus/features/web/admin_company/schedule_management_screen.dart';
import 'package:new_ebus/features/web/admin_company/monitoring_screen.dart';
import 'package:new_ebus/features/web/super_admin/dashboard/super_admin_dashboard.dart';
import 'package:new_ebus/features/web/super_admin/reports/super_admin_report_screen.dart';
import 'package:new_ebus/features/web/super_admin/user_management/user_management_screen.dart';

import '../../features/auth/splash_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/auth/forgot_password/forgot_password_screen.dart';
import '../../features/web/admin_company/admin_company_dashboard.dart';
import '../../features/web/super_admin/company_management/company_management_screen.dart';
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
        builder: (context, state) => const DriverHomeScreen(),
      ),

      GoRoute(
        path: '/passenger-main',
        builder: (context, state) => const PassengerMainScreen(),
      ),

      GoRoute(
        path: "/armada",
        builder: (context, state) => const ArmadaScreen(companyId: 2),
      ),

      GoRoute(
        path: "/route",
        builder: (context, state) => const RouteManagementScreen(),
      ),

      GoRoute(
        path: "/terminal",
        builder: (context, state) => const TerminalManagementScreen(),
      ),

      GoRoute(
        path: "/schedule",
        builder: (context, state) => const ScheduleManagementScreen(),
      ),

      GoRoute(
        path: "/driver",
        builder: (context, state) => const DriverManagementScreen(),
      ),

      GoRoute(
        path: "/monitoring",
        builder: (context, state) => const MonitoringScreen(),
      ),

      GoRoute(
        path: "/report",
        builder: (context, state) => const ReportScreen(),
      ),

      GoRoute(
        path: "/setting",
        builder: (context, state) => const SettingScreen(),
      ),

      GoRoute(
        path: RouteNames.companyManagement,
        builder: (context, state) => const CompanyManagementScreen(),
      ),

      GoRoute(
        path: "/user-management",
        builder: (context, state) => const UserManagementScreen(),
      ),

      GoRoute(
        path: "/super-admin-report",
        builder: (context, state) => const SuperAdminReportScreen(),
      ),

      GoRoute(
        path: "/passenger-tracking",
        builder: (_, __) =>
            const PassengerTrackingInputScreen(),
      ),
    ],
  );
}
