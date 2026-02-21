import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/models/sensor_data.dart';
import 'package:monitor/widgets/status_card.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/providers/sensor_provider.dart';
import 'package:monitor/services/api_service.dart';
import 'package:monitor/providers/bed_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  Future<void> _fetchSensorData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Safely get bed provider
      final bedProvider = context.read<BedProvider>();
      final bedId = bedProvider.selectedBed?.id ?? 'bed_1';

      final sensorData = await _apiService.getLatestSensorData(bedId);

      if (mounted) {
        context.read<SensorProvider>().updateSensorData(sensorData);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sensor data';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _fetchSensorData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              title: const Text(
                'VermiCompost',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.primaryDark,
              elevation: 0,
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
              ],
            ),

            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (_errorMessage != null) {
                    return _buildErrorWidget();
                  }

                  return Consumer<SensorProvider>(
                    builder: (context, sensorProvider, child) {
                      final sensorData = sensorProvider.sensorData;
                      final isAutoMode = sensorProvider.isAutoMode;
                      final isPumpOn = sensorProvider.isPumpActive;

                      return Column(
                        children: [
                          // Welcome Text
                          _buildWelcomeHeader(),
                          const SizedBox(height: 10),

                          // Status Bar
                          _buildStatusBar(isAutoMode, isPumpOn),
                          const SizedBox(height: 10),

                          // Dashboard Grid
                          _buildDashboardGrid(sensorData),
                          const SizedBox(height: 10),

                          // Health Status
                          _buildHealthStatus(sensorData),
                          const SizedBox(height: 24),

                          // Quick Actions
                          _buildQuickActions(),
                          const SizedBox(height: 8),

                          // Last Updated Timestamp
                          _buildLastUpdated(sensorData.lastUpdated),
                        ],
                      );
                    },
                  );
                }, childCount: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Farmer! 👋',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Compost bed is looking good',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(bool isAutoMode, bool isPumpOn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isAutoMode
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      isAutoMode ? Icons.auto_awesome : Icons.touch_app,
                      size: 14,
                      color: isAutoMode ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isAutoMode ? 'AUTO' : 'MANUAL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAutoMode
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isPumpOn ? AppColors.success : Colors.grey[400],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isPumpOn ? 'PUMP ON' : 'PUMP OFF',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPumpOn ? AppColors.success : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardGrid(SensorData sensorData) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: [
        StatusCard(
          title: 'Moisture',
          value: '${sensorData.moisture.toStringAsFixed(1)}%',
          icon: Icons.water_drop,
          color: _getMoistureColor(sensorData.moisture),
          trend: sensorData.moisture > 70
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          unit: 'Level',
        ),
        StatusCard(
          title: 'Temperature',
          value: '${sensorData.temperature.toStringAsFixed(1)}°C',
          icon: Icons.thermostat,
          color: _getTemperatureColor(sensorData.temperature),
          trend: sensorData.temperature > 30
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          unit: 'Optimal',
        ),
        StatusCard(
          title: 'pH Value',
          value: sensorData.ph.toStringAsFixed(1),
          icon: Icons.science,
          color: _getPHColor(sensorData.ph),
          trend: sensorData.ph > 7.5
              ? Icons.arrow_upward
              : Icons.arrow_downward,
          unit: 'Neutral',
        ),
        StatusCard(
          title: 'Compost Age',
          value: 'Day ${sensorData.compostDay ?? 15}',
          icon: Icons.calendar_today,
          color: AppColors.info,
          trend: Icons.trending_flat,
          unit: 'of 45',
        ),
      ],
    );
  }

  Widget _buildHealthStatus(SensorData sensorData) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Icon(
            _getHealthIcon(sensorData.healthStatus),
            color: _getHealthColor(sensorData.healthStatus),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Health Status',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatTime(sensorData.lastUpdated),
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sensorData.healthStatus.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getHealthColor(sensorData.healthStatus),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _fetchSensorData,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCompactActionButton(
                icon: Icons.play_arrow,
                label: 'Water Now',
                color: AppColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, '/control');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCompactActionButton(
                icon: Icons.history_toggle_off,
                label: 'History',
                color: AppColors.secondary,
                onPressed: () {
                  Navigator.pushNamed(context, '/status');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLastUpdated(DateTime lastUpdated) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.update, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            'Last updated: ${_formatDateTime(lastUpdated)}',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 50, color: AppColors.danger),
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Please check your connection',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchSensorData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getMoistureColor(double moisture) {
    if (moisture < 60) return AppColors.danger;
    if (moisture < 70) return AppColors.warning;
    return AppColors.success;
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 25 || temp > 35) return AppColors.danger;
    if (temp < 27 || temp > 33) return AppColors.warning;
    return AppColors.success;
  }

  Color _getPHColor(double ph) {
    if (ph < 6.5 || ph > 7.5) return AppColors.danger;
    if (ph < 6.8 || ph > 7.2) return AppColors.warning;
    return AppColors.success;
  }

  Color _getHealthColor(String healthStatus) {
    switch (healthStatus.toLowerCase()) {
      case 'healthy':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'critical':
        return AppColors.danger;
      default:
        return AppColors.info;
    }
  }

  IconData _getHealthIcon(String healthStatus) {
    switch (healthStatus.toLowerCase()) {
      case 'healthy':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning_amber;
      case 'critical':
        return Icons.error_outline;
      default:
        return Icons.info_outline;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
