import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Smart Vermi Compost',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Multi-Bed Control System',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'v2.0.0',
                      style: TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),

            // Dashboard
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              route: '/dashboard',
              isSelected: currentRoute == '/dashboard',
            ),

            // Control Panel
            _buildDrawerItem(
              icon: Icons.sensors,
              title: 'Control Panel',
              route: '/control',
              isSelected: currentRoute == '/control',
            ),

            // Analytics
            _buildDrawerItem(
              icon: Icons.analytics,
              title: 'Analytics',
              route: '/status',
              isSelected: currentRoute == '/status',
            ),

            // Guide
            _buildDrawerItem(
              icon: Icons.menu_book,
              title: 'Compost Guide',
              route: '/guide',
              isSelected: currentRoute == '/guide',
            ),

            const Divider(),

            // Profile
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Profile',
              route: '/profile',
              isSelected: currentRoute == '/profile',
            ),

            // Notifications
            _buildDrawerItem(
              icon: Icons.notifications,
              title: 'Notifications',
              route: '/notifications',
              isSelected: currentRoute == '/notifications',
              badge: '3',
            ),

            // Settings
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              route: '/settings',
              isSelected: currentRoute == '/settings',
            ),

            const Divider(),

            // Help
            _buildDrawerItem(
              icon: Icons.help,
              title: 'Help & Support',
              route: '/help',
              isSelected: false,
            ),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.danger),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.danger),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),

            const SizedBox(height: 20),

            // Version info at bottom
            Center(
              child: Text(
                '© 2024 Smart Vermi Compost',
                style: TextStyle(fontSize: 10, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
    String? badge,
  }) {
    return Container(
      color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
        onTap: () => onNavigate(route),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
              Navigator.pushReplacementNamed(context, '/splash');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
