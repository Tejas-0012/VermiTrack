import 'package:flutter/material.dart';
import 'package:monitor/screens/dashboard_screen.dart';
import 'package:monitor/screens/control_screen.dart';
import 'package:monitor/screens/status_screen.dart';
import 'package:monitor/screens/guide_screen.dart';
import 'package:monitor/screens/profile_screen.dart';
import 'package:monitor/widgets/bottom_nav_bar.dart';
import 'package:monitor/widgets/floating_chat_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Screen list
  static final List<Widget> _screens = [
    const DashboardScreen(),
    const ControlScreen(),
    const StatusScreen(),
    const GuideScreen(),
    const ProfileScreen(),
  ];

  // Screen titles for AppBar
  static final List<String> _screenTitles = [
    'VermiCompost',
    'Water Control',
    'Compost Analytics',
    'Compost Guide',
    'Profile & Settings',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: const FloatingChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
