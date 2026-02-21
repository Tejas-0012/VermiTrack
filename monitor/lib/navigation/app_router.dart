import 'package:flutter/material.dart';
import 'package:monitor/screens/dashboard_screen.dart';
import 'package:monitor/screens/bed_control_screen.dart';
import 'package:monitor/screens/splash_screen.dart';
import 'package:monitor/screens/main_screen.dart';
import 'package:monitor/screens/home_screen.dart';
import 'package:monitor/screens/control_screen.dart';
import 'package:monitor/screens/status_screen.dart';
import 'package:monitor/screens/guide_screen.dart';
import 'package:monitor/screens/profile_screen.dart';
import 'package:monitor/screens/notifications_screen.dart';
import 'package:monitor/screens/chat_screen.dart';
import 'package:monitor/screens/command_history_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/main':
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case '/bed-control':
        return MaterialPageRoute(builder: (_) => const BedControlScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/control':
        return MaterialPageRoute(builder: (_) => const ControlScreen());

      case '/status':
        return MaterialPageRoute(builder: (_) => const StatusScreen());

      case '/guide':
        return MaterialPageRoute(builder: (_) => const GuideScreen());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case '/notifications':
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      case '/command-history':
        final bedId = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => CommandHistoryScreen(bedId: bedId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
