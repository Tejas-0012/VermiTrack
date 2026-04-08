import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/screens/bed_control_screen.dart';
import 'package:monitor/widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Theme mode state
  bool _isDarkMode = false;

  // 📊 6 Mock Beds with all features
  final List<Map<String, dynamic>> _mockBeds = [
    {
      'id': 'bed_1',
      'name': 'Main Bed',
      'status': BedStatus.running,
      'temperature': 28.5,
      'moisture': 65.2,
      'ph': 7.2,
      'currentLayer': 3,
      'totalLayers': 5,
      'gateStatus': GateStatus.closed,
      'conveyorRunning': true,
      'mixerRunning': false,
      'compostDay': 15,
      'errorMessage': null,
      'healthScore': 92,
      'worms': 1200,
      'lastFed': '2h ago',
    },
    {
      'id': 'bed_2',
      'name': 'Secondary Bed',
      'status': BedStatus.drying,
      'temperature': 32.1,
      'moisture': 48.5,
      'ph': 6.8,
      'currentLayer': 2,
      'totalLayers': 5,
      'gateStatus': GateStatus.open,
      'conveyorRunning': false,
      'mixerRunning': true,
      'compostDay': 8,
      'errorMessage': null,
      'healthScore': 65,
      'worms': 800,
      'lastFed': '5h ago',
    },
    {
      'id': 'bed_3',
      'name': 'Harvest Bed',
      'status': BedStatus.done,
      'temperature': 24.2,
      'moisture': 72.3,
      'ph': 7.5,
      'currentLayer': 5,
      'totalLayers': 5,
      'gateStatus': GateStatus.closed,
      'conveyorRunning': false,
      'mixerRunning': false,
      'compostDay': 42,
      'errorMessage': null,
      'healthScore': 98,
      'worms': 1500,
      'lastFed': '1d ago',
    },
    {
      'id': 'bed_4',
      'name': 'Experimental',
      'status': BedStatus.error,
      'temperature': 38.5,
      'moisture': 80.1,
      'ph': 8.2,
      'currentLayer': 2,
      'totalLayers': 5,
      'gateStatus': GateStatus.opening,
      'conveyorRunning': false,
      'mixerRunning': false,
      'compostDay': 12,
      'errorMessage': 'Sensor failure',
      'healthScore': 35,
      'worms': 600,
      'lastFed': '3h ago',
    },
    {
      'id': 'bed_5',
      'name': 'New Setup',
      'status': BedStatus.idle,
      'temperature': 26.3,
      'moisture': 58.7,
      'ph': 7.0,
      'currentLayer': 1,
      'totalLayers': 5,
      'gateStatus': GateStatus.closed,
      'conveyorRunning': false,
      'mixerRunning': false,
      'compostDay': 3,
      'errorMessage': null,
      'healthScore': 85,
      'worms': 500,
      'lastFed': 'Just now',
    },
    {
      'id': 'bed_6',
      'name': 'Quick Compost',
      'status': BedStatus.running,
      'temperature': 29.8,
      'moisture': 62.4,
      'ph': 7.1,
      'currentLayer': 4,
      'totalLayers': 5,
      'gateStatus': GateStatus.closed,
      'conveyorRunning': true,
      'mixerRunning': true,
      'compostDay': 28,
      'errorMessage': null,
      'healthScore': 88,
      'worms': 1100,
      'lastFed': '1h ago',
    },
  ];

  // System metrics
  final Map<String, dynamic> _systemMetrics = {
    'totalWorms': 5700,
    'totalCompost': 124.5,
    'activeTime': '156h',
    'efficiency': 94,
    'alerts': 3,
    'tasks': 5,
  };

  // Recent activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'bed': 'Main Bed',
      'action': 'Layer 3 added',
      'time': '5 min ago',
      'icon': Icons.layers,
      'color': AppColors.success,
    },
    {
      'bed': 'Secondary Bed',
      'action': 'Watering completed',
      'time': '15 min ago',
      'icon': Icons.water_drop,
      'color': AppColors.primary,
    },
    {
      'bed': 'Experimental',
      'action': '⚠️ High temperature',
      'time': '32 min ago',
      'icon': Icons.warning,
      'color': AppColors.danger,
    },
    {
      'bed': 'Quick Compost',
      'action': 'Mixer activated',
      'time': '1h ago',
      'icon': Icons.autorenew,
      'color': AppColors.info,
    },
    {
      'bed': 'Harvest Bed',
      'action': 'Ready for harvest',
      'time': '2h ago',
      'icon': Icons.agriculture,
      'color': AppColors.warning,
    },
  ];

  // Upcoming tasks
  final List<Map<String, dynamic>> _upcomingTasks = [
    {
      'bed': 'Main Bed',
      'task': 'Add Layer 4',
      'due': 'In 2h',
      'priority': 'High',
      'color': AppColors.danger,
    },
    {
      'bed': 'Secondary Bed',
      'task': 'Check moisture',
      'due': 'In 4h',
      'priority': 'Medium',
      'color': AppColors.warning,
    },
    {
      'bed': 'Quick Compost',
      'task': 'Feed worms',
      'due': 'Tomorrow',
      'priority': 'Low',
      'color': AppColors.success,
    },
    {
      'bed': 'Harvest Bed',
      'task': 'Harvest compost',
      'due': 'Tomorrow',
      'priority': 'High',
      'color': AppColors.danger,
    },
  ];

  String _selectedTimeRange = 'Today';
  final List<String> _timeRanges = ['Today', 'Week', 'Month'];

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    final totalBeds = _mockBeds.length;
    final runningBeds = _mockBeds
        .where((b) => b['status'] == BedStatus.running)
        .length;
    final dryingBeds = _mockBeds
        .where((b) => b['status'] == BedStatus.drying)
        .length;
    final doneBeds = _mockBeds
        .where((b) => b['status'] == BedStatus.done)
        .length;
    final errorBeds = _mockBeds
        .where((b) => b['status'] == BedStatus.error)
        .length;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme() : _lightTheme(),
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _isDarkMode
            ? AppColors.backgroundDark
            : AppColors.background,
        drawer: AppDrawer(
          currentRoute: '/dashboard',
          onNavigate: (route) {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, route);
          },
        ),
        body: CustomScrollView(
          slivers: [
            // SECTION 1: TITLE SECTION (VermiTrack)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
                decoration: BoxDecoration(
                  gradient: _isDarkMode
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey[850]!, Colors.grey[900]!],
                        )
                      : AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.glowGreen.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Colors.white,
                                  AppColors.glowLightGreen,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                'VermiTrack',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Smart Farming',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Theme Toggle Button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isDarkMode = !_isDarkMode;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/notifications',
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            if (_systemMetrics['alerts'] > 0)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.dangerGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.danger.withOpacity(
                                          0.5,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${_systemMetrics['alerts']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // SECTION 2: WELCOME SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                  decoration: BoxDecoration(
                    gradient: _isDarkMode
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[800]!, Colors.grey[850]!],
                          )
                        : AppColors.successGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.glowGreen.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Farmer! 👨🏻‍🌾',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'What would you like to monitor today?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // SECTION 3: OVERVIEW CARDS
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOverviewCard(
                      label: 'Worms',
                      value: '${_systemMetrics['totalWorms']}',
                      imagePath: 'assets/images/worm.gif',
                      color: Colors.amber,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildOverviewCard(
                      label: 'Compost',
                      value: '${_systemMetrics['totalCompost']}kg',
                      icon: Icons.scale,
                      color: AppColors.glowLightGreen,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildOverviewCard(
                      label: 'Active',
                      value: _systemMetrics['activeTime'],
                      icon: Icons.timer,
                      color: AppColors.infoLight,
                      isDarkMode: _isDarkMode,
                    ),
                    _buildOverviewCard(
                      label: 'Efficiency',
                      value: '${_systemMetrics['efficiency']}%',
                      icon: Icons.speed,
                      color: const Color.fromARGB(255, 16, 176, 11),
                      isDarkMode: _isDarkMode,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // System Metrics Cards
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Live Metrics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildMetricCard(index, _isDarkMode),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Status Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Status Overview Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final statuses = [
                    {
                      'title': 'Active',
                      'icon': Icons.play_circle,
                      'color': AppColors.success,
                      'gradient': AppColors.successGradient,
                      'count': runningBeds,
                      'badge': 'Running',
                    },
                    {
                      'title': 'Need Water',
                      'icon': Icons.water_drop,
                      'color': AppColors.warning,
                      'gradient': AppColors.warningGradient,
                      'count': dryingBeds,
                      'badge': 'Warning',
                    },
                    {
                      'title': 'Ready',
                      'icon': Icons.check_circle,
                      'color': AppColors.info,
                      'gradient': AppColors.infoGradient,
                      'count': doneBeds,
                      'badge': 'Harvest',
                    },
                    {
                      'title': 'Issues',
                      'icon': Icons.warning,
                      'color': AppColors.danger,
                      'gradient': AppColors.dangerGradient,
                      'count': errorBeds,
                      'badge': 'Critical',
                    },
                  ];

                  final status = statuses[index];

                  return Container(
                    decoration: BoxDecoration(
                      gradient: _isDarkMode
                          ? null
                          : LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: (status['gradient'] as LinearGradient)
                                  .colors
                                  .map((c) => c.withOpacity(0.1))
                                  .toList(),
                            ),
                      color: _isDarkMode ? Colors.grey[850] : null,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (status['color'] as Color).withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: (status['color'] as Color).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 6,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: (status['color'] as Color).withOpacity(
                                0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (status['color'] as Color).withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              status['badge'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: status['color'] as Color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                status['icon'] as IconData,
                                color: status['color'] as Color,
                                size: 15,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                status['title'] as String,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${status['count']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: status['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: 4),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // How is your compost today? Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How is your compost today?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Smart recommendations based on bed activity',
                      style: TextStyle(
                        fontSize: 13,
                        color: _isDarkMode
                            ? Colors.grey[400]
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // AI Recommendation Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isDarkMode
                          ? [
                              Colors.cyan.withOpacity(0.15),
                              Colors.blue.withOpacity(0.05),
                            ]
                          : [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.info.withOpacity(0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (_isDarkMode ? Colors.cyan : AppColors.primary)
                          .withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isDarkMode ? Colors.cyan : AppColors.primary)
                            .withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI Compost Assistant',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: _isDarkMode
                                ? Colors.grey[300]
                                : AppColors.textPrimary,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: 'Perfect conditions! '),
                            TextSpan(
                              text: '$runningBeds running',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                            const TextSpan(text: ' beds and '),
                            TextSpan(
                              text: '$dryingBeds need water',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '. Current temperature 28°C is ideal for decomposition.\n\n',
                            ),
                            const TextSpan(
                              text:
                                  'Recommendations: Water drying beds, harvest ready beds, and check error bed sensors.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildActionChip(
                            'View Details',
                            Icons.analytics,
                            AppColors.primary,
                            _isDarkMode,
                          ),
                          const SizedBox(width: 8),
                          _buildActionChip(
                            'Take Action',
                            Icons.touch_app,
                            AppColors.info,
                            _isDarkMode,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Farm Statistics
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farm Statistics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickStatCard(
                          'Total Worms',
                          '${_systemMetrics['totalWorms']}',
                          Icons.psychology,
                          AppColors.primary,
                          '+230 today',
                          _isDarkMode,
                        ),
                        _buildQuickStatCard(
                          'Compost Ready',
                          '${_systemMetrics['totalCompost']} kg',
                          Icons.scale,
                          AppColors.success,
                          '${doneBeds} beds ready',
                          _isDarkMode,
                        ),
                        _buildQuickStatCard(
                          'Active Time',
                          _systemMetrics['activeTime'],
                          Icons.timer,
                          AppColors.info,
                          '${_systemMetrics['efficiency']}% efficiency',
                          _isDarkMode,
                        ),
                        _buildQuickStatCard(
                          'Tasks',
                          '${_systemMetrics['tasks']}',
                          Icons.task_alt,
                          AppColors.warning,
                          '3 due soon',
                          _isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Your Beds Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Beds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(40, 20),
                      ),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 11,
                          color: _isDarkMode
                              ? AppColors.glowNeon
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Beds Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final bedData = _mockBeds[index];
                  final bed = BedModel.fromJson(bedData);
                  final healthScore = bedData['healthScore'] ?? 85;
                  final worms = bedData['worms'] ?? 800;

                  return GestureDetector(
                    onTap: () {
                      Provider.of<BedProvider>(
                        context,
                        listen: false,
                      ).selectBed(bed.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BedControlScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isDarkMode
                            ? AppColors.surfaceDark
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(bed.status).withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: _getStatusColor(bed.status).withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Health Score Badge
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getHealthColor(
                                      healthScore,
                                    ).withOpacity(0.15),
                                    _getHealthColor(
                                      healthScore,
                                    ).withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getHealthColor(
                                    healthScore,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 10,
                                    color: _getHealthColor(healthScore),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$healthScore%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getHealthColor(healthScore),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bed Name
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getStatusColor(bed.status),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getStatusColor(
                                              bed.status,
                                            ).withOpacity(0.5),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        bed.name,
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: _isDarkMode
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Temperature and Moisture
                                Row(
                                  children: [
                                    _buildBedStat(
                                      Icons.thermostat,
                                      '${bed.temperature.toStringAsFixed(0)}°',
                                      _getTempColor(bed.temperature),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBedStat(
                                      Icons.water_drop,
                                      '${bed.moisture.toStringAsFixed(0)}%',
                                      _getMoistureColor(bed.moisture),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                // Layer and Worms
                                Row(
                                  children: [
                                    _buildBedStat(
                                      Icons.layers,
                                      'L${bed.currentLayer}/${bed.totalLayers}',
                                      AppColors.info,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBedStat(
                                      Icons.psychology,
                                      '$worms',
                                      AppColors.primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Last Fed and Day
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bedData['lastFed'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _isDarkMode
                                            ? Colors.grey[500]
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getStatusColor(
                                              bed.status,
                                            ).withOpacity(0.15),
                                            _getStatusColor(
                                              bed.status,
                                            ).withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Day ${bed.compostDay}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(bed.status),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: _mockBeds.length),
              ),
            ),

            // Recent Activity and Tasks
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildActivityCard(_isDarkMode)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildTasksCard(_isDarkMode)),
                  ],
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  // Light Theme
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: AppColors.shadowLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      useMaterial3: true,
    );
  }

  // Dark Theme
  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: AppColors.glowGreen.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      useMaterial3: true,
    );
  }

  // Small Overview Card
  Widget _buildOverviewCard({
    required String label,
    required String value,
    String? imagePath,
    IconData? icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                )
              : Icon(icon, color: const Color.fromARGB(255, 0, 0, 0), size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(179, 0, 0, 0),
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Metric Card
  Widget _buildMetricCard(int index, bool isDarkMode) {
    final metrics = [
      {
        'icon': Icons.sensors,
        'label': 'Active Beds',
        'value':
            '${_mockBeds.where((b) => b['conveyorRunning'] == true).length}/6',
        'color': AppColors.success,
      },
      {
        'icon': Icons.opacity,
        'label': 'Avg Moisture',
        'value': '64%',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.thermostat,
        'label': 'Avg Temp',
        'value': '28°C',
        'color': AppColors.warning,
      },
      {
        'icon': Icons.speed,
        'label': 'Efficiency',
        'value': '${_systemMetrics['efficiency']}%',
        'color': AppColors.info,
      },
    ];

    final metric = metrics[index];

    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (metric['color'] as Color).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (metric['color'] as Color).withOpacity(0.2),
                  (metric['color'] as Color).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: (metric['color'] as Color).withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              metric['icon'] as IconData,
              color: metric['color'] as Color,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric['value'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: metric['color'] as Color,
                  ),
                ),
                Text(
                  metric['label'] as String,
                  style: TextStyle(
                    fontSize: 9,
                    color: isDarkMode
                        ? Colors.grey[400]
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quick Stat Card
  Widget _buildQuickStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.grey[400]
                        : AppColors.textSecondary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode
                        ? Colors.grey[500]
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bed Stat
  Widget _buildBedStat(IconData icon, String value, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Action Chip
  Widget _buildActionChip(
    String label,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Activity Card
  Widget _buildActivityCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]
              : [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.cyan : AppColors.primary).withOpacity(
              0.15,
            ),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 20),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? AppColors.glowNeon : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentActivities.take(3).map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (activity['color'] as Color).withOpacity(0.2),
                          (activity['color'] as Color).withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (activity['color'] as Color).withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      size: 10,
                      color: activity['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['action'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${activity['bed']} • ${activity['time']}',
                          style: TextStyle(
                            fontSize: 8,
                            color: isDarkMode
                                ? Colors.grey[500]
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Tasks Card
  Widget _buildTasksCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [Colors.white.withOpacity(0.05), Colors.white.withOpacity(0.02)]
              : [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.cyan : AppColors.primary).withOpacity(
              0.15,
            ),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Tasks',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: AppColors.warningGradient,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warning.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  '${_systemMetrics['tasks']}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._upcomingTasks.take(3).map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 2,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          task['color'] as Color,
                          (task['color'] as Color).withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                      boxShadow: [
                        BoxShadow(
                          color: (task['color'] as Color).withOpacity(0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['task'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${task['bed']} • ${task['due']}',
                          style: TextStyle(
                            fontSize: 8,
                            color: isDarkMode
                                ? Colors.grey[500]
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (task['color'] as Color).withOpacity(0.2),
                          (task['color'] as Color).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task['priority'],
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: task['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStatusColor(BedStatus status) {
    switch (status) {
      case BedStatus.running:
        return AppColors.success;
      case BedStatus.drying:
        return AppColors.warning;
      case BedStatus.done:
        return AppColors.info;
      case BedStatus.error:
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getHealthColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.danger;
  }

  Color _getTempColor(double temp) {
    if (temp < 25 || temp > 35) return AppColors.danger;
    if (temp < 27 || temp > 33) return AppColors.warning;
    return AppColors.success;
  }

  Color _getMoistureColor(double moisture) {
    if (moisture < 55) return AppColors.danger;
    if (moisture > 70) return AppColors.warning;
    return AppColors.success;
  }
}
