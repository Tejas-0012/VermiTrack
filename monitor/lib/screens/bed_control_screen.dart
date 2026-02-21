import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/widgets/control_button.dart';
import 'package:monitor/widgets/layer_indicator.dart';
import 'package:monitor/models/layer_sequence.dart';

class BedControlScreen extends StatefulWidget {
  const BedControlScreen({super.key});

  @override
  State<BedControlScreen> createState() => _BedControlScreenState();
}

class _BedControlScreenState extends State<BedControlScreen> {
  bool _isAutoMode = false;
  bool _isSendingCommand = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BedProvider>(
      builder: (context, provider, child) {
        final bed = provider.selectedBed;
        if (bed == null) {
          return const Scaffold(body: Center(child: Text('No bed selected')));
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(bed),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Machine Status Bar
                  SliverToBoxAdapter(child: _buildMachineStatusBar(bed)),

                  // Main Control Panel
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Layer Progress
                        _buildLayerProgress(bed),
                        const SizedBox(height: 20),

                        // Sensor Display
                        _buildSensorPanel(bed),
                        const SizedBox(height: 20),

                        // Auto/Manual Mode Toggle
                        _buildModeToggle(),
                        const SizedBox(height: 20),

                        // Process Control
                        _buildProcessControls(bed),
                        const SizedBox(height: 20),

                        // Machine Controls
                        _buildMachineControls(bed),
                        const SizedBox(height: 20),

                        // Layer Controls
                        _buildLayerControls(bed),
                        const SizedBox(height: 20),

                        // Gate Controls
                        _buildGateControls(bed),
                        const SizedBox(height: 20),

                        // Quick Actions
                        _buildQuickActions(bed),
                        const SizedBox(height: 20),

                        // Danger Zone
                        if (bed.status == BedStatus.running)
                          _buildDangerZone(bed),
                        const SizedBox(height: 30),
                      ]),
                    ),
                  ),
                ],
              ),

              // Loading Overlay
              if (_isSendingCommand)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BedModel bed) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bed.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            'Status: ${bed.status.toString().split('.').last}',
            style: TextStyle(fontSize: 12, color: _getStatusColor(bed.status)),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryDark,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            Provider.of<BedProvider>(context, listen: false).fetchBed(bed.id);
          },
        ),
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => _showCommandHistory(context, bed.id),
        ),
      ],
    );
  }

  Widget _buildMachineStatusBar(BedModel bed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusIndicator('Conveyor', bed.conveyorRunning, Icons.sensors),
          _buildStatusIndicator('Mixer', bed.mixerRunning, Icons.autorenew),
          _buildStatusIndicator(
            'Gate',
            bed.gateStatus == GateStatus.open,
            Icons.door_sliding,
            value: bed.gateStatus == GateStatus.open ? 'OPEN' : 'CLOSED',
          ),
          _buildStatusIndicator(
            'Layer',
            true,
            Icons.layers,
            value: '${bed.currentLayer}/${bed.totalLayers}',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(
    String label,
    bool isActive,
    IconData icon, {
    String? value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.success : AppColors.textSecondary,
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          value ?? (isActive ? 'ON' : 'OFF'),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.success : AppColors.textSecondary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLayerProgress(BedModel bed) {
    return Container(
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
                'Layer Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Layer ${bed.currentLayer} of ${bed.totalLayers}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: bed.currentLayer / bed.totalLayers,
            backgroundColor: Colors.grey[200],
            color: AppColors.primary,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLayerInfo(
                'Current',
                _getCurrentLayerName(bed.currentLayer),
              ),
              _buildLayerInfo('Next', _getNextLayerName(bed.currentLayer)),
              _buildLayerInfo(
                'Remaining',
                '${bed.totalLayers - bed.currentLayer}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLayerInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSensorPanel(BedModel bed) {
    return Container(
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
            'Live Sensors',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSensorCard(
                  'Temperature',
                  '${bed.temperature.toStringAsFixed(1)}°C',
                  Icons.thermostat,
                  _getTempColor(bed.temperature),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSensorCard(
                  'Moisture',
                  '${bed.moisture.toStringAsFixed(0)}%',
                  Icons.water_drop,
                  _getMoistureColor(bed.moisture),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSensorCard(
                  'pH Level',
                  bed.ph.toStringAsFixed(1),
                  Icons.science,
                  _getPHColor(bed.ph),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSensorCard(
                  'Compost Day',
                  'Day ${bed.compostDay}',
                  Icons.calendar_today,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Operation Mode',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeButton('MANUAL', !_isAutoMode, () {
                  setState(() => _isAutoMode = false);
                }),
                const SizedBox(width: 4),
                _buildModeButton('AUTO', _isAutoMode, () {
                  setState(() => _isAutoMode = true);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProcessControls(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Process Control',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ControlButton(
                label: 'START',
                icon: Icons.play_arrow,
                color: AppColors.success,
                onPressed: bed.status == BedStatus.running
                    ? null
                    : () => _sendCommand('start_process'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ControlButton(
                label: 'STOP',
                icon: Icons.stop,
                color: AppColors.warning,
                onPressed: bed.status != BedStatus.running
                    ? null
                    : () => _sendCommand('stop_process'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMachineControls(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Machine Controls',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ControlButton(
                label: bed.conveyorRunning ? 'STOP CONVEYOR' : 'START CONVEYOR',
                icon: Icons.sensors,
                color: bed.conveyorRunning
                    ? AppColors.warning
                    : AppColors.primary,
                onPressed: () => _sendCommand(
                  bed.conveyorRunning ? 'stop_conveyor' : 'start_conveyor',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ControlButton(
                label: bed.mixerRunning ? 'STOP MIXER' : 'START MIXER',
                icon: Icons.autorenew,
                color: bed.mixerRunning ? AppColors.warning : AppColors.primary,
                onPressed: () => _sendCommand(
                  bed.mixerRunning ? 'stop_mixer' : 'start_mixer',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLayerControls(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Layer Controls',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ControlButton(
                label: 'PREV LAYER',
                icon: Icons.arrow_upward,
                color: AppColors.info,
                onPressed: bed.currentLayer <= 1
                    ? null
                    : () => _sendCommand('previous_layer'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ControlButton(
                label: 'NEXT LAYER',
                icon: Icons.arrow_downward,
                color: AppColors.info,
                onPressed: bed.currentLayer >= bed.totalLayers
                    ? null
                    : () => _sendCommand('next_layer'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGateControls(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gate Control',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ControlButton(
                label: 'OPEN GATE',
                icon: Icons.door_sliding,
                color: AppColors.success,
                onPressed: bed.gateStatus == GateStatus.open
                    ? null
                    : () => _sendCommand('open_gate'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ControlButton(
                label: 'CLOSE GATE',
                icon: Icons.door_sliding,
                color: AppColors.danger,
                onPressed: bed.gateStatus == GateStatus.closed
                    ? null
                    : () => _sendCommand('close_gate'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickActionChip('Auto Layer', Icons.layers, () {
              _startAutoLayering();
            }),
            _buildQuickActionChip('Reset', Icons.refresh, () {
              _showResetDialog(bed.id);
            }),
            _buildQuickActionChip('Calibrate', Icons.tune, () {
              _sendCommand('calibrate');
            }),
            _buildQuickActionChip('History', Icons.history, () {
              _showCommandHistory(context, bed.id);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionChip(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: AppColors.primary),
    );
  }

  Widget _buildDangerZone(BedModel bed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚠️ Danger Zone',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showEmergencyDialog(bed.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, size: 24),
                SizedBox(width: 8),
                Text(
                  'EMERGENCY STOP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper Methods
  String _getCurrentLayerName(int layer) {
    switch (layer) {
      case 1:
        return 'Cow Dung';
      case 2:
        return 'Dry Leaves';
      case 3:
        return 'Green Waste';
      case 4:
        return 'Cocopeat';
      case 5:
        return 'Worms';
      default:
        return 'Unknown';
    }
  }

  String _getNextLayerName(int currentLayer) {
    final next = currentLayer + 1;
    if (next > 5) return 'Complete';
    return _getCurrentLayerName(next);
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
        return AppColors.textSecondary;
    }
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

  // Command Methods
  Future<void> _sendCommand(String command) async {
    setState(() => _isSendingCommand = true);
    try {
      final provider = Provider.of<BedProvider>(context, listen: false);
      await provider.sendCommand(provider.selectedBed!.id, command);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Command sent: $command'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger),
      );
    } finally {
      setState(() => _isSendingCommand = false);
    }
  }

  void _startAutoLayering() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Auto Layering'),
        content: const Text(
          'This will automatically run through all 5 layers:\n\n'
          '1. Cow Dung Layer\n'
          '2. Dry Leaves Layer\n'
          '3. Green Waste Layer\n'
          '4. Cocopeat Layer\n'
          '5. Worm Introduction\n\n'
          'Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendCommand('start_process');
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(String bedId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Bed?'),
        content: const Text('This will reset all progress. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendCommand('reset_bed');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(String bedId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('EMERGENCY STOP?'),
        content: const Text(
          'This will immediately stop ALL operations!\n\nAre you absolutely sure?',
          style: TextStyle(color: AppColors.danger),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendCommand('emergency_stop');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('EMERGENCY STOP'),
          ),
        ],
      ),
    );
  }

  void _showCommandHistory(BuildContext context, String bedId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Command History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<BedProvider>(
                  context,
                  listen: false,
                ).getBedCommandHistory(bedId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final commands = snapshot.data ?? [];
                  if (commands.isEmpty) {
                    return const Center(child: Text('No commands yet'));
                  }
                  return ListView.builder(
                    itemCount: commands.length,
                    itemBuilder: (context, index) {
                      final cmd = commands[index];
                      return ListTile(
                        leading: Icon(
                          _getCommandIcon(cmd.type.toString()),
                          color: cmd.isExecuted
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        title: Text(cmd.type.toString().split('.').last),
                        subtitle: Text(
                          '${cmd.timestamp.hour}:${cmd.timestamp.minute}',
                        ),
                        trailing: cmd.isExecuted
                            ? const Icon(Icons.check, color: AppColors.success)
                            : const Icon(
                                Icons.pending,
                                color: AppColors.warning,
                              ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCommandIcon(String commandType) {
    if (commandType.contains('start')) return Icons.play_arrow;
    if (commandType.contains('stop')) return Icons.stop;
    if (commandType.contains('gate')) return Icons.door_sliding;
    if (commandType.contains('conveyor')) return Icons.sensors;
    if (commandType.contains('mixer')) return Icons.autorenew;
    return Icons.code;
  }
}
