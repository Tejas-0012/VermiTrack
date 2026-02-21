import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/screens/bed_control_screen.dart';
import 'package:monitor/widgets/bed_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 📊 LOCAL MOCK DATA for dashboard overview
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
    'totalCompost': 124.5, // kg
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 140,
              floating: true,
              pinned: true,
              backgroundColor: AppColors.primaryDark,
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalBeds Beds • $runningBeds Running',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryDark, AppColors.primary],
                    ),
                  ),
                ),
              ),
              actions: [
                // Time range selector
                PopupMenuButton<String>(
                  icon: const Icon(Icons.calendar_today),
                  onSelected: (value) {
                    setState(() {
                      _selectedTimeRange = value;
                    });
                  },
                  itemBuilder: (context) {
                    return _timeRanges.map((range) {
                      return PopupMenuItem(value: range, child: Text(range));
                    }).toList();
                  },
                ),
                // Notifications with badge
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                    if (_systemMetrics['alerts'] > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${_systemMetrics['alerts']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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

            // System Metrics Cards
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return _buildMetricCard(index);
                  },
                ),
              ),
            ),

            // Status Overview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatusOverviewCard(
                        'Running',
                        runningBeds,
                        totalBeds,
                        AppColors.success,
                        Icons.play_circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusOverviewCard(
                        'Drying',
                        dryingBeds,
                        totalBeds,
                        AppColors.warning,
                        Icons.water,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusOverviewCard(
                        'Done',
                        doneBeds,
                        totalBeds,
                        AppColors.info,
                        Icons.check_circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusOverviewCard(
                        'Error',
                        errorBeds,
                        totalBeds,
                        AppColors.danger,
                        Icons.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Stats Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    _buildQuickStatCard(
                      'Total Worms',
                      '${_systemMetrics['totalWorms']}',
                      Icons.psychology,
                      AppColors.primary,
                      '+230 today',
                    ),
                    _buildQuickStatCard(
                      'Compost Ready',
                      '${_systemMetrics['totalCompost']} kg',
                      Icons.scale,
                      AppColors.success,
                      '${doneBeds} beds ready',
                    ),
                    _buildQuickStatCard(
                      'Active Time',
                      _systemMetrics['activeTime'],
                      Icons.timer,
                      AppColors.info,
                      '92% efficiency',
                    ),
                    _buildQuickStatCard(
                      'Tasks',
                      '${_systemMetrics['tasks']}',
                      Icons.task_alt,
                      AppColors.warning,
                      '3 due soon',
                    ),
                  ],
                ),
              ),
            ),

            // Beds Grid Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Text(
                  'Your Beds',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Beds Grid
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final bedData = _mockBeds[index];
                  final bed = BedModel.fromJson(bedData);

                  // Add extra fields for dashboard
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: _getStatusColor(bed.status).withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Health Score Badge
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getHealthColor(
                                  healthScore,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
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
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: _getHealthColor(healthScore),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Bed Name and Status
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _getStatusColor(bed.status),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        bed.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
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
                                    _buildMiniSensor(
                                      Icons.thermostat,
                                      '${bed.temperature.toStringAsFixed(0)}°',
                                      _getTempColor(bed.temperature),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMiniSensor(
                                      Icons.water_drop,
                                      '${bed.moisture.toStringAsFixed(0)}%',
                                      _getMoistureColor(bed.moisture),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Layer and Worms
                                Row(
                                  children: [
                                    _buildMiniInfo(
                                      Icons.layers,
                                      'L${bed.currentLayer}/${bed.totalLayers}',
                                      AppColors.info,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildMiniInfo(
                                      Icons.psychology,
                                      '$worms',
                                      AppColors.primary,
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // Last Fed and Progress
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      bedData['lastFed'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          bed.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Day ${bed.compostDay}',
                                        style: TextStyle(
                                          fontSize: 8,
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
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recent Activity
                    Expanded(child: _buildActivityCard()),
                    const SizedBox(width: 12),
                    // Upcoming Tasks
                    Expanded(child: _buildTasksCard()),
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

  Widget _buildMetricCard(int index) {
    final metrics = [
      {
        'icon': Icons.sensors,
        'label': 'Active Beds',
        'value': '4/6',
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
      margin: const EdgeInsets.only(right: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            metric['icon'] as IconData,
            color: metric['color'] as Color,
            size: 18,
          ),
          const SizedBox(height: 8),
          Text(
            metric['value'] as String,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: metric['color'] as Color,
            ),
          ),
          Text(
            metric['label'] as String,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOverviewCard(
    String label,
    int count,
    int total,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniSensor(IconData icon, String value, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String value, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(value, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 20),
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentActivities.take(4).map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: (activity['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activity['icon'] as IconData,
                      size: 12,
                      color: activity['color'] as Color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['action'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${activity['bed']} • ${activity['time']}',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
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

  Widget _buildTasksCard() {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Tasks',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_systemMetrics['tasks']} tasks',
                  style: TextStyle(fontSize: 9, color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._upcomingTasks.map((task) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 2,
                    height: 30,
                    decoration: BoxDecoration(
                      color: task['color'] as Color,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task['task'],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${task['bed']} • ${task['due']}',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (task['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task['priority'],
                      style: TextStyle(
                        fontSize: 8,
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
