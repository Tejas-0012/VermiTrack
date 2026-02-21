import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _selectedTimeRange = '7 Days';
  final List<String> _timeRanges = [
    '24 Hours',
    '7 Days',
    '30 Days',
    '3 Months',
  ];
  int _selectedChart = 0;
  final List<String> _chartTypes = ['Moisture', 'Temperature', 'pH', 'All'];

  // 📊 LOCAL MOCK DATA - Different for each bed
  final Map<String, Map<String, dynamic>> _mockData = {
    'bed_1': {
      'moisture': [65, 62, 58, 61, 67, 70, 68, 66, 63, 59, 62, 65, 68, 71, 69],
      'temperature': [
        28,
        29,
        31,
        30,
        28,
        27,
        26,
        28,
        29,
        30,
        31,
        29,
        28,
        27,
        26,
      ],
      'ph': [
        7.2,
        7.1,
        7.0,
        7.1,
        7.2,
        7.3,
        7.2,
        7.1,
        7.0,
        7.1,
        7.2,
        7.1,
        7.0,
        6.9,
        7.0,
      ],
      'avgTemp': 28.4,
      'avgMoisture': 64.7,
      'avgPH': 7.1,
      'cycles': 2,
      'machineHours': 48,
    },
    'bed_2': {
      'moisture': [45, 48, 52, 50, 47, 44, 42, 45, 48, 52, 55, 53, 50, 48, 46],
      'temperature': [
        32,
        33,
        34,
        33,
        32,
        31,
        30,
        31,
        32,
        33,
        34,
        33,
        32,
        31,
        30,
      ],
      'ph': [
        6.8,
        6.9,
        7.0,
        6.9,
        6.8,
        6.7,
        6.8,
        6.9,
        7.0,
        7.1,
        7.0,
        6.9,
        6.8,
        6.9,
        7.0,
      ],
      'avgTemp': 32.1,
      'avgMoisture': 48.3,
      'avgPH': 6.9,
      'cycles': 1,
      'machineHours': 32,
    },
    'bed_3': {
      'moisture': [72, 70, 68, 65, 63, 62, 60, 62, 64, 66, 68, 70, 72, 71, 69],
      'temperature': [
        24,
        25,
        26,
        25,
        24,
        23,
        22,
        23,
        24,
        25,
        26,
        25,
        24,
        23,
        22,
      ],
      'ph': [
        7.5,
        7.4,
        7.3,
        7.2,
        7.3,
        7.4,
        7.5,
        7.4,
        7.3,
        7.2,
        7.3,
        7.4,
        7.5,
        7.4,
        7.3,
      ],
      'avgTemp': 24.2,
      'avgMoisture': 66.8,
      'avgPH': 7.4,
      'cycles': 3,
      'machineHours': 56,
    },
  };

  List<FlSpot> _moistureData = [];
  List<FlSpot> _temperatureData = [];
  List<FlSpot> _phData = [];

  // Daily logs for the table
  final List<Map<String, dynamic>> _dailyLogs = [
    {
      'day': 1,
      'moisture': 65,
      'temp': 28,
      'ph': 7.2,
      'action': 'Layering started',
    },
    {'day': 2, 'moisture': 62, 'temp': 29, 'ph': 7.1, 'action': 'Watered'},
    {'day': 3, 'moisture': 58, 'temp': 31, 'ph': 7.0, 'action': 'Mixed'},
    {'day': 4, 'moisture': 61, 'temp': 30, 'ph': 7.1, 'action': 'Gate opened'},
    {'day': 5, 'moisture': 67, 'temp': 28, 'ph': 7.2, 'action': 'Fed worms'},
    {'day': 6, 'moisture': 70, 'temp': 27, 'ph': 7.3, 'action': 'Watered'},
    {
      'day': 7,
      'moisture': 68,
      'temp': 26,
      'ph': 7.2,
      'action': 'Layer 2 added',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadMockDataForBed('bed_1'); // Default bed
  }

  void _loadMockDataForBed(String bedId) {
    final data = _mockData[bedId] ?? _mockData['bed_1']!;

    setState(() {
      _moistureData = (data['moisture'] as List).asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.toDouble());
      }).toList();

      _temperatureData = (data['temperature'] as List).asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.toDouble());
      }).toList();

      _phData = (data['ph'] as List).asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.toDouble());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BedProvider>(
      builder: (context, provider, child) {
        final bed =
            provider.selectedBed ??
            (provider.beds.isNotEmpty ? provider.beds.first : null);

        // Load data for selected bed
        if (bed != null) {
          _loadMockDataForBed(bed.id);
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // App Bar with Bed Selector
              SliverAppBar(
                title: const Text(
                  'Compost Analytics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                backgroundColor: AppColors.primaryDark,
                elevation: 0,
                floating: true,
                snap: true,
                actions: [
                  if (provider.beds.length > 1)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.bed, size: 22),
                      onSelected: (bedId) {
                        provider.selectBed(bedId);
                        _loadMockDataForBed(bedId);
                      },
                      itemBuilder: (context) {
                        return provider.beds.map((bed) {
                          return PopupMenuItem(
                            value: bed.id,
                            child: Text(bed.name),
                          );
                        }).toList();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 22),
                    onPressed: () {
                      if (bed != null) {
                        _loadMockDataForBed(bed.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data refreshed')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, size: 22),
                    onPressed: _exportData,
                  ),
                ],
              ),

              // Bed Info if selected
              if (bed != null)
                SliverToBoxAdapter(child: _buildBedInfoHeader(bed)),

              // KPI Cards Row
              if (bed != null) SliverToBoxAdapter(child: _buildKPICards(bed)),

              // Chart Selector
              SliverToBoxAdapter(child: _buildChartSelector()),

              // Chart
              SliverToBoxAdapter(child: _buildChart()),

              // Time Range Selector
              SliverToBoxAdapter(child: _buildTimeRangeSelector()),

              // Current Parameters
              if (bed != null)
                SliverToBoxAdapter(child: _buildCurrentParameters(bed)),

              // Statistics Grid
              if (bed != null) SliverToBoxAdapter(child: _buildStatsGrid(bed)),

              // Daily Logs Table
              SliverToBoxAdapter(child: _buildDailyLogs()),

              // Machine Usage
              if (bed != null)
                SliverToBoxAdapter(child: _buildMachineStats(bed)),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBedInfoHeader(BedModel bed) {
    final mock = _mockData[bed.id] ?? _mockData['bed_1']!;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(bed.status),
            _getStatusColor(bed.status).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(bed.status).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                bed.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  bed.status.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(bed.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem('Day', '${bed.compostDay}', Icons.calendar_today),
              _buildInfoItem('Layer', '${bed.currentLayer}/5', Icons.layers),
              _buildInfoItem('Cycles', '${mock['cycles']}', Icons.recycling),
              _buildInfoItem('Hours', '${mock['machineHours']}h', Icons.timer),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildKPICards(BedModel bed) {
    final mock = _mockData[bed.id] ?? _mockData['bed_1']!;

    return Container(
      margin: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: _buildKPICard(
              'Avg Temp',
              '${mock['avgTemp']}°C',
              Icons.thermostat,
              _getTempColor(mock['avgTemp']),
              Icons.trending_up,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildKPICard(
              'Avg Moisture',
              '${mock['avgMoisture']}%',
              Icons.water_drop,
              _getMoistureColor(mock['avgMoisture']),
              Icons.trending_down,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildKPICard(
              'Avg pH',
              mock['avgPH'].toString(),
              Icons.science,
              _getPHColor(mock['avgPH']),
              Icons.trending_flat,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    Color color,
    IconData trend,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 16),
              Icon(trend, color: color, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _chartTypes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(_chartTypes[index]),
              selected: _selectedChart == index,
              onSelected: (selected) {
                setState(() => _selectedChart = index);
              },
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: _selectedChart == index
                    ? Colors.white
                    : AppColors.textPrimary,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart() {
    List<FlSpot> data;
    Color color;
    double minY, maxY;
    String label;

    switch (_selectedChart) {
      case 0: // Moisture
        data = _moistureData;
        color = AppColors.primary;
        minY = 40;
        maxY = 80;
        label = 'Moisture %';
        break;
      case 1: // Temperature
        data = _temperatureData;
        color = AppColors.warning;
        minY = 20;
        maxY = 40;
        label = 'Temperature °C';
        break;
      case 2: // pH
        data = _phData;
        color = AppColors.info;
        minY = 6.0;
        maxY = 8.0;
        label = 'pH Level';
        break;
      case 3: // All
        return _buildCombinedChart();
      default:
        data = _moistureData;
        color = AppColors.primary;
        minY = 40;
        maxY = 80;
        label = 'Moisture %';
    }

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _selectedChart == 2 ? 0.5 : 10,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: _selectedChart == 2 ? 0.5 : 10,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedChart() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _moistureData.length.toDouble() - 1,
          minY: 0,
          maxY: 80,
          lineBarsData: [
            LineChartBarData(
              spots: _moistureData,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: _temperatureData
                  .map((e) => FlSpot(e.x, e.y * 2))
                  .toList(), // Scale temp
              isCurved: true,
              color: AppColors.warning,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
            LineChartBarData(
              spots: _phData
                  .map((e) => FlSpot(e.x, e.y * 10))
                  .toList(), // Scale pH
              isCurved: true,
              color: AppColors.info,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _timeRanges.map((range) {
          final isSelected = _selectedTimeRange == range;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                range,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedTimeRange = range);
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentParameters(BedModel bed) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Parameters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildParamCard(
                  'Temperature',
                  '${bed.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                  _getTempColor(bed.temperature),
                  _getTempStatus(bed.temperature),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildParamCard(
                  'Moisture',
                  '${bed.moisture.toStringAsFixed(0)}%',
                  Icons.water_drop,
                  _getMoistureColor(bed.moisture),
                  _getMoistureStatus(bed.moisture),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildParamCard(
                  'pH Level',
                  bed.ph.toStringAsFixed(1),
                  Icons.science,
                  _getPHColor(bed.ph),
                  _getPHStatus(bed.ph),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildParamCard(
                  'Health',
                  bed.status.toString().split('.').last,
                  Icons.health_and_safety,
                  _getStatusColor(bed.status),
                  '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParamCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              if (status.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 9, color: color),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BedModel bed) {
    final mock = _mockData[bed.id] ?? _mockData['bed_1']!;

    return Container(
      margin: const EdgeInsets.all(12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildStatItem(
            'Avg Temperature',
            '${mock['avgTemp']}°C',
            Icons.thermostat,
            AppColors.primary,
            '+0.3°',
          ),
          _buildStatItem(
            'Avg Moisture',
            '${mock['avgMoisture']}%',
            Icons.water_drop,
            AppColors.success,
            '-2.1%',
          ),
          _buildStatItem(
            'Cycles Completed',
            '${mock['cycles']}',
            Icons.recycling,
            AppColors.info,
            '',
          ),
          _buildStatItem(
            'Machine Hours',
            '${mock['machineHours']}h',
            Icons.sensors,
            AppColors.warning,
            '+4h',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    String trend,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 16),
              if (trend.isNotEmpty)
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 10,
                    color: trend.startsWith('+')
                        ? AppColors.success
                        : trend.startsWith('-')
                        ? AppColors.danger
                        : AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyLogs() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                'Daily Activity Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dailyLogs.length,
            itemBuilder: (context, index) {
              final log = _dailyLogs[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: index < _dailyLogs.length - 1
                      ? Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'D${log['day']}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['action'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Moisture: ${log['moisture']}%  •  Temp: ${log['temp']}°C  •  pH: ${log['ph']}',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getActionColor(log['action']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getActionType(log['action']),
                        style: TextStyle(
                          fontSize: 9,
                          color: _getActionColor(log['action']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMachineStats(BedModel bed) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Machine Usage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildMachineUsageRow(
            'Conveyor',
            bed.conveyorRunning ? 75 : 30,
            Icons.sensors,
            AppColors.primary,
            '${bed.conveyorRunning ? 12 : 4}h',
          ),
          const SizedBox(height: 12),
          _buildMachineUsageRow(
            'Mixer',
            bed.mixerRunning ? 60 : 20,
            Icons.autorenew,
            AppColors.success,
            '${bed.mixerRunning ? 8 : 3}h',
          ),
          const SizedBox(height: 12),
          _buildMachineUsageRow(
            'Gate',
            bed.gateStatus == GateStatus.open ? 25 : 5,
            Icons.door_front_door,
            AppColors.info,
            '${bed.gateStatus == GateStatus.open ? 2 : 0.5}h',
          ),
        ],
      ),
    );
  }

  Widget _buildMachineUsageRow(
    String label,
    int percent,
    IconData icon,
    Color color,
    String hours,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: Colors.grey[200],
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          hours,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
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

  Color _getTempColor(double temp) {
    if (temp < 25 || temp > 35) return AppColors.danger;
    if (temp < 27 || temp > 33) return AppColors.warning;
    return AppColors.success;
  }

  String _getTempStatus(double temp) {
    if (temp < 25) return 'Low';
    if (temp > 35) return 'High';
    if (temp < 27 || temp > 33) return 'Warning';
    return 'Optimal';
  }

  Color _getMoistureColor(double moisture) {
    if (moisture < 55) return AppColors.danger;
    if (moisture > 70) return AppColors.warning;
    return AppColors.success;
  }

  String _getMoistureStatus(double moisture) {
    if (moisture < 55) return 'Dry';
    if (moisture > 70) return 'Wet';
    return 'Optimal';
  }

  Color _getPHColor(double ph) {
    if (ph < 6.5 || ph > 7.5) return AppColors.danger;
    if (ph < 6.8 || ph > 7.2) return AppColors.warning;
    return AppColors.success;
  }

  String _getPHStatus(double ph) {
    if (ph < 6.5) return 'Acidic';
    if (ph > 7.5) return 'Alkaline';
    if (ph < 6.8 || ph > 7.2) return 'Warning';
    return 'Neutral';
  }

  Color _getActionColor(String action) {
    if (action.contains('Water')) return AppColors.primary;
    if (action.contains('Layer')) return AppColors.success;
    if (action.contains('Mix')) return AppColors.warning;
    if (action.contains('Gate')) return AppColors.info;
    if (action.contains('Fed')) return AppColors.success;
    return AppColors.textSecondary;
  }

  String _getActionType(String action) {
    if (action.contains('Water')) return 'WATER';
    if (action.contains('Layer')) return 'LAYER';
    if (action.contains('Mix')) return 'MIX';
    if (action.contains('Gate')) return 'GATE';
    if (action.contains('Fed')) return 'FEED';
    return 'OTHER';
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Data exported as CSV'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
