import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/models/farmer_profile.dart';
import 'package:monitor/widgets/setting_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FarmerProfile _farmerProfile = FarmerProfile(
    name: 'Rajesh Kumar',
    phone: '+91 98765 43210',
    email: 'rajesh.farmer@example.com',
    location: 'Rampur, Pune',
    bedSize: 'Medium (2x4 ft)',
    wormCount: '1000',
    compostCycles: 3,
    joinDate: DateTime(2023, 6, 15),
    notificationsEnabled: true,
    autoModeEnabled: true,
    language: 'English',
    themeMode: 'Light',
  );

  final List<Map<String, dynamic>> _settings = [
    {
      'category': 'Account',
      'items': [
        {
          'icon': Icons.person,
          'title': 'Edit Profile',
          'subtitle': 'Update info',
          'type': 'navigate',
        },
        {
          'icon': Icons.bed,
          'title': 'Bed Settings',
          'subtitle': 'Configure bed',
          'type': 'navigate',
        },
        {
          'icon': Icons.history,
          'title': 'History',
          'subtitle': 'Past cycles',
          'type': 'navigate',
        },
      ],
    },
    {
      'category': 'App Settings',
      'items': [
        {
          'icon': Icons.notifications,
          'title': 'Notifications',
          'subtitle': 'Alert preferences',
          'type': 'toggle',
          'value': true,
        },
        {
          'icon': Icons.language,
          'title': 'Language',
          'subtitle': 'App language',
          'type': 'select',
          'value': 'English',
          'options': ['English', 'हिन्दी', 'मराठी', 'தமிழ்'],
        },
        {
          'icon': Icons.dark_mode,
          'title': 'Theme',
          'subtitle': 'Light/dark mode',
          'type': 'select',
          'value': 'Light',
          'options': ['Light', 'Dark', 'Auto'],
        },
        {
          'icon': Icons.autorenew,
          'title': 'Auto Mode',
          'subtitle': 'Auto watering',
          'type': 'toggle',
          'value': true,
        },
      ],
    },
    {
      'category': 'Support',
      'items': [
        {
          'icon': Icons.help,
          'title': 'Help & Support',
          'subtitle': 'Get help',
          'type': 'navigate',
        },
        {
          'icon': Icons.feedback,
          'title': 'Feedback',
          'subtitle': 'Share experience',
          'type': 'navigate',
        },
        {
          'icon': Icons.share,
          'title': 'Share App',
          'subtitle': 'Share with farmers',
          'type': 'action',
        },
        {
          'icon': Icons.star,
          'title': 'Rate App',
          'subtitle': 'Rate on Play Store',
          'type': 'action',
        },
      ],
    },
    {
      'category': 'About',
      'items': [
        {
          'icon': Icons.info,
          'title': 'About',
          'subtitle': 'Version 1.0.0',
          'type': 'navigate',
        },
        {
          'icon': Icons.privacy_tip,
          'title': 'Privacy',
          'subtitle': 'Data handling',
          'type': 'navigate',
        },
        {
          'icon': Icons.description,
          'title': 'Terms',
          'subtitle': 'Usage terms',
          'type': 'navigate',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            title: const Text(
              'Profile & Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            floating: true,
            snap: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, size: 22),
                onPressed: _editProfile,
              ),
            ],
          ),

          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile Header (Compact)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _farmerProfile.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _farmerProfile.phone,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _farmerProfile.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Since ${_farmerProfile.joinDate.year}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Statistics (Compact)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.9,
                  children: [
                    _buildCompactStatCard(
                      title: 'Cycles',
                      value: _farmerProfile.compostCycles.toString(),
                      icon: Icons.recycling,
                      color: AppColors.primary,
                    ),
                    _buildCompactStatCard(
                      title: 'Bed Size',
                      value: _farmerProfile.bedSize,
                      icon: Icons.square_foot,
                      color: AppColors.success,
                    ),
                    _buildCompactStatCard(
                      title: 'Worms',
                      value: _farmerProfile.wormCount,
                      icon: Icons.psychology,
                      color: AppColors.warning,
                    ),
                    _buildCompactStatCard(
                      title: 'Success',
                      value: '92%',
                      icon: Icons.trending_up,
                      color: AppColors.info,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Settings List
                ..._settings.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          category['category'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: (category['items'] as List)
                              .asMap()
                              .entries
                              .map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final isLast =
                                    index ==
                                    (category['items'] as List).length - 1;

                                return Container(
                                  decoration: BoxDecoration(
                                    border: isLast
                                        ? null
                                        : Border(
                                            bottom: BorderSide(
                                              color: AppColors.border,
                                              width: 0.5,
                                            ),
                                          ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            item['icon'],
                                            size: 18,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['title'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['subtitle'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (item['type'] == 'toggle')
                                          Switch(
                                            value: item['value'] ?? false,
                                            onChanged: (value) {
                                              _handleSettingChange(
                                                category['category'],
                                                item['title'],
                                                value,
                                              );
                                            },
                                            activeThumbColor: AppColors.primary,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        if (item['type'] == 'select')
                                          Text(
                                            item['value'] ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        if (item['type'] == 'navigate' ||
                                            item['type'] == 'action')
                                          Icon(
                                            Icons.chevron_right,
                                            size: 20,
                                            color: AppColors.textSecondary,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),

                // Logout Button (Compact)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger.withOpacity(0.1),
                      foregroundColor: AppColors.danger,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      side: BorderSide(
                        color: AppColors.danger.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildCompactEditField('Name', _farmerProfile.name, (value) {
                setState(() {
                  _farmerProfile = _farmerProfile.copyWith(name: value);
                });
              }),
              const SizedBox(height: 10),
              _buildCompactEditField('Phone', _farmerProfile.phone, (value) {
                setState(() {
                  _farmerProfile = _farmerProfile.copyWith(phone: value);
                });
              }),
              const SizedBox(height: 10),
              _buildCompactEditField('Email', _farmerProfile.email, (value) {
                setState(() {
                  _farmerProfile = _farmerProfile.copyWith(email: value);
                });
              }),
              const SizedBox(height: 10),
              _buildCompactEditField('Location', _farmerProfile.location, (
                value,
              ) {
                setState(() {
                  _farmerProfile = _farmerProfile.copyWith(location: value);
                });
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Profile updated'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(8),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactEditField(
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  void _handleSettingChange(String category, String title, dynamic newValue) {
    setState(() {
      if (category == 'App Settings') {
        switch (title) {
          case 'Notifications':
            _farmerProfile = _farmerProfile.copyWith(
              notificationsEnabled: newValue,
            );
            break;
          case 'Auto Mode':
            _farmerProfile = _farmerProfile.copyWith(autoModeEnabled: newValue);
            break;
          case 'Language':
            _farmerProfile = _farmerProfile.copyWith(language: newValue);
            break;
          case 'Theme':
            _farmerProfile = _farmerProfile.copyWith(themeMode: newValue);
            break;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title updated'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _performLogout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
      ),
    );
  }
}
