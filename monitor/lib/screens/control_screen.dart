import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/screens/bed_control_screen.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
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
      'healthScore': 92,
      'worms': 1200,
      'lastFed': '2h ago',
      'errorMessage': null,
    },
    {
      'id': 'bed_2',
      'name': 'Drying Bed',
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
      'healthScore': 65,
      'worms': 800,
      'lastFed': '5h ago',
      'errorMessage': null,
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
      'healthScore': 98,
      'worms': 1500,
      'lastFed': '1d ago',
      'errorMessage': null,
    },
    {
      'id': 'bed_4',
      'name': 'Error Bed',
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
      'healthScore': 35,
      'worms': 600,
      'lastFed': '3h ago',
      'errorMessage': 'Sensor failure',
    },
    {
      'id': 'bed_5',
      'name': 'New Bed',
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
      'healthScore': 85,
      'worms': 500,
      'lastFed': 'Just now',
      'errorMessage': null,
    },
    {
      'id': 'bed_6',
      'name': 'Quick Bed',
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
      'healthScore': 88,
      'worms': 1100,
      'lastFed': '1h ago',
      'errorMessage': null,
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

  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Running',
    'Drying',
    'Done',
    'Error',
    'Idle',
  ];
  String _searchQuery = '';
  bool _isGridView = true;

  List<BedModel> get _filteredBeds {
    return _mockBeds
        .where((bedData) {
          final bed = BedModel.fromJson(bedData);

          if (_selectedFilter != 'All') {
            final filterStatus = _selectedFilter.toLowerCase();
            if (bed.status.toString().split('.').last.toLowerCase() !=
                filterStatus) {
              return false;
            }
          }

          if (_searchQuery.isNotEmpty) {
            return bed.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }

          return true;
        })
        .map((bedData) => BedModel.fromJson(bedData))
        .toList();
  }

  Map<String, int> get _statusCounts {
    return {
      'All': _mockBeds.length,
      'Running': _mockBeds
          .where((b) => b['status'] == BedStatus.running)
          .length,
      'Drying': _mockBeds.where((b) => b['status'] == BedStatus.drying).length,
      'Done': _mockBeds.where((b) => b['status'] == BedStatus.done).length,
      'Error': _mockBeds.where((b) => b['status'] == BedStatus.error).length,
      'Idle': _mockBeds.where((b) => b['status'] == BedStatus.idle).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with all actions
          SliverAppBar(
            title: const Text(
              'Control Panel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            floating: true,
            snap: true,
            actions: [
              // Notification Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 20),
                    onPressed: _showNotifications,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  if (_systemMetrics['alerts'] > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '${_systemMetrics['alerts']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // View Toggle
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  size: 20,
                ),
                onPressed: () => setState(() => _isGridView = !_isGridView),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              // Refresh
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () => setState(() {}),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search beds...',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 16,
                      color: Colors.grey,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () => setState(() => _searchQuery = ''),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),

          // Filter Chips with counts
          SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final count = _statusCounts[filter] ?? 0;
                  final isSelected = _selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            filter,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : _getFilterColor(filter).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? _getFilterColor(filter)
                                    : _getFilterColor(filter),
                              ),
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) =>
                          setState(() => _selectedFilter = filter),
                      backgroundColor: Colors.white,
                      selectedColor: _getFilterColor(filter),
                      checkmarkColor: Colors.white,
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
            ),
          ),

          // System Metrics Cards (Horizontal scroll)
          SliverToBoxAdapter(
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildMetricCard(index);
                },
              ),
            ),
          ),

          // Stats Summary Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      _statusCounts['All'].toString(),
                      Icons.bed,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildStatCard(
                      'Running',
                      _statusCounts['Running'].toString(),
                      Icons.play_arrow,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildStatCard(
                      'Issues',
                      (_statusCounts['Error']! + _statusCounts['Drying']!)
                          .toString(),
                      Icons.warning,
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _buildStatCard(
                      'Done',
                      _statusCounts['Done'].toString(),
                      Icons.check_circle,
                      AppColors.info,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Stats Grid (2x2)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
                children: [
                  _buildQuickStatCard(
                    'Worms',
                    '${_systemMetrics['totalWorms']}',
                    Icons.psychology,
                    AppColors.primary,
                  ),
                  _buildQuickStatCard(
                    'Compost',
                    '${_systemMetrics['totalCompost']}kg',
                    Icons.scale,
                    AppColors.success,
                  ),
                  _buildQuickStatCard(
                    'Active',
                    _systemMetrics['activeTime'],
                    Icons.timer,
                    AppColors.info,
                  ),
                  _buildQuickStatCard(
                    'Tasks',
                    '${_systemMetrics['tasks']}',
                    Icons.task_alt,
                    AppColors.warning,
                  ),
                ],
              ),
            ),
          ),

          // Beds Grid/List Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Text(
                'Your Beds',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          // Beds Grid/List
          if (_filteredBeds.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bed_outlined, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'No beds matching "$_searchQuery"'
                          : 'No beds with status "$_selectedFilter"',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'All';
                          _searchQuery = '';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        minimumSize: const Size(100, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Clear Filters',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_isGridView)
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final bed = _filteredBeds[index];
                  return _buildGridBedCard(bed, index);
                }, childCount: _filteredBeds.length),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final bed = _filteredBeds[index];
                  return _buildListBedCard(bed, index);
                }, childCount: _filteredBeds.length),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),

      // Floating Action Button (kept but smaller)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 70,
        ), // Add bottom padding to raise it
        child: FloatingActionButton(
          onPressed: _showQuickActions,
          backgroundColor: AppColors.primary,
          mini: true,
          child: const Icon(Icons.speed, size: 18),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildMetricCard(int index) {
    final metrics = [
      {
        'icon': Icons.sensors,
        'label': 'Active',
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
      width: 100,
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: (metric['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              metric['icon'] as IconData,
              color: metric['color'] as Color,
              size: 14,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric['value'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: metric['color'] as Color,
                  ),
                ),
                Text(
                  metric['label'] as String,
                  style: TextStyle(fontSize: 8, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 8, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 8, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridBedCard(BedModel bed, int index) {
    final bedData = _mockBeds.firstWhere((b) => b['id'] == bed.id);

    return GestureDetector(
      onTap: () {
        Provider.of<BedProvider>(context, listen: false).selectBed(bed.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BedControlScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _getStatusColor(bed.status).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Health Score Badge
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: _getHealthColor(
                    bedData['healthScore'],
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 6,
                      color: _getHealthColor(bedData['healthScore']),
                    ),
                    const SizedBox(width: 1),
                    Text(
                      '${bedData['healthScore']}%',
                      style: TextStyle(
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                        color: _getHealthColor(bedData['healthScore']),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bed Name and Status
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(bed.status),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          bed.name,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Sensors Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSensorItem(
                        Icons.thermostat,
                        '${bed.temperature.toStringAsFixed(0)}°',
                        _getTempColor(bed.temperature),
                      ),
                      _buildSensorItem(
                        Icons.water_drop,
                        '${bed.moisture.toStringAsFixed(0)}%',
                        _getMoistureColor(bed.moisture),
                      ),
                      _buildSensorItem(
                        Icons.science,
                        bed.ph.toStringAsFixed(1),
                        _getPHColor(bed.ph),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Layer and Worms
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        Icons.layers,
                        'L${bed.currentLayer}/5',
                        AppColors.info,
                      ),
                      _buildInfoItem(
                        Icons.psychology,
                        '${bedData['worms']}',
                        AppColors.primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Machine Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMachineIcon(Icons.sensors, bed.conveyorRunning),
                      _buildMachineIcon(Icons.autorenew, bed.mixerRunning),
                      _buildMachineIcon(
                        Icons.door_front_door,
                        bed.gateStatus == GateStatus.open,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Last Fed and Day
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bedData['lastFed'] ?? '',
                        style: TextStyle(fontSize: 7, color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(bed.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Day ${bed.compostDay}',
                          style: TextStyle(
                            fontSize: 6,
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
  }

  Widget _buildListBedCard(BedModel bed, int index) {
    final bedData = _mockBeds.firstWhere((b) => b['id'] == bed.id);

    return GestureDetector(
      onTap: () {
        Provider.of<BedProvider>(context, listen: false).selectBed(bed.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BedControlScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getStatusColor(bed.status).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Status Indicator
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: _getStatusColor(bed.status),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),

              // Bed Icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getStatusColor(bed.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getStatusIcon(bed.status),
                  color: _getStatusColor(bed.status),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),

              // Bed Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bed.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: _getHealthColor(
                              bedData['healthScore'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 8,
                                color: _getHealthColor(bedData['healthScore']),
                              ),
                              const SizedBox(width: 1),
                              Text(
                                '${bedData['healthScore']}%',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: _getHealthColor(
                                    bedData['healthScore'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.thermostat,
                          '${bed.temperature.toStringAsFixed(0)}°',
                          _getTempColor(bed.temperature),
                        ),
                        const SizedBox(width: 6),
                        _buildInfoChip(
                          Icons.water_drop,
                          '${bed.moisture.toStringAsFixed(0)}%',
                          _getMoistureColor(bed.moisture),
                        ),
                        const SizedBox(width: 6),
                        _buildInfoChip(
                          Icons.layers,
                          'L${bed.currentLayer}/5',
                          AppColors.info,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorItem(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 8, color: color),
        const SizedBox(width: 1),
        Text(
          value,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 8, color: color),
        const SizedBox(width: 1),
        Text(value, style: TextStyle(fontSize: 8, color: color)),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 8, color: color),
          const SizedBox(width: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 7,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineIcon(IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 12,
      color: isActive ? AppColors.success : Colors.grey,
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickActionButton(
                  'Start All',
                  Icons.play_arrow,
                  AppColors.success,
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Starting all beds...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  'Stop All',
                  Icons.stop,
                  AppColors.warning,
                  () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Stopping all beds...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                _buildQuickActionButton(
                  'Emergency',
                  Icons.warning,
                  AppColors.danger,
                  () {
                    Navigator.pop(context);
                    _showEmergencyDialog();
                  },
                ),
                _buildQuickActionButton(
                  'Reset All',
                  Icons.refresh,
                  AppColors.info,
                  () {
                    Navigator.pop(context);
                    _showResetDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.1),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: color.withOpacity(0.3)),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          children: [
            Icon(icon, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    title: const Text(
                      'High Temperature',
                      style: TextStyle(fontSize: 13),
                    ),
                    subtitle: const Text(
                      'Bed 4 • 2 min ago',
                      style: TextStyle(fontSize: 11),
                    ),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Emergency Stop?',
          style: TextStyle(fontSize: 16, color: AppColors.danger),
        ),
        content: const Text(
          'Stop ALL running beds?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('⚠️ Emergency stop activated'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('STOP', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All?', style: TextStyle(fontSize: 16)),
        content: const Text(
          'Reset all beds to initial state?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 12)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All beds reset')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Reset', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'Running':
        return AppColors.success;
      case 'Drying':
        return AppColors.warning;
      case 'Done':
        return AppColors.info;
      case 'Error':
        return AppColors.danger;
      case 'Idle':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

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
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(BedStatus status) {
    switch (status) {
      case BedStatus.running:
        return Icons.play_circle;
      case BedStatus.drying:
        return Icons.water;
      case BedStatus.done:
        return Icons.check_circle;
      case BedStatus.error:
        return Icons.error;
      default:
        return Icons.bed;
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

  Color _getPHColor(double ph) {
    if (ph < 6.5 || ph > 7.5) return AppColors.danger;
    if (ph < 6.8 || ph > 7.2) return AppColors.warning;
    return AppColors.success;
  }
}
