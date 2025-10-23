import 'package:go_router/go_router.dart';

import '../../ui/screens/loadingScreen.dart';
import '../../ui/screens/loginScreen.dart';
import '../../ui/screens/homeScreen.dart';
import '../../ui/screens/dashboardScreen.dart';
import '../../ui/screens/devicesScreen.dart';
import '../../ui/screens/tripsScreen.dart';
import '../../ui/screens/trackingScreen.dart';
import '../../ui/screens/reportsScreen.dart';
import '../../ui/screens/alertsScreen.dart';
import '../../ui/screens/settingsScreen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      //ShellRoute keeps HomeScreen layout persistent
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/home/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/home/devices',
            name: 'devices',
            builder: (context, state) => const DevicesScreen(),
          ),
          GoRoute(
            path: '/home/trips',
            name: 'trips',
            builder: (context, state) => const TripsScreen(),
          ),
          GoRoute(
            path: '/home/tracking',
            name: 'tracking',
            builder: (context, state) => const TrackingScreen(),
          ),
          GoRoute(
            path: '/home/reports',
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/home/alerts',
            name: 'alerts',
            builder: (context, state) => const AlertsScreen(),
          ),
          GoRoute(
            path: '/home/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
