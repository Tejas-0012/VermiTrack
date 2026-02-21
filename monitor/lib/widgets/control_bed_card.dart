import 'package:flutter/material.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';

class ControlBedCard extends StatelessWidget {
  final BedModel bed;
  final VoidCallback onTap;

  const ControlBedCard({super.key, required this.bed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            color: _getStatusColor().withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bed.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getStatusColor(),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Sensors Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                    const Divider(height: 12),

                    // Machine Status Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMachineIcon(
                          Icons.sensors,
                          bed.conveyorRunning,
                          'Conv',
                        ),
                        _buildMachineIcon(
                          Icons.autorenew,
                          bed.mixerRunning,
                          'Mix',
                        ),
                        _buildMachineIcon(
                          Icons.door_front_door,
                          bed.gateStatus == GateStatus.open,
                          'Gate',
                        ),
                      ],
                    ),

                    // Layer Progress
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.layers,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Layer ${bed.currentLayer}/${bed.totalLayers}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Action Buttons
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickButton(
                    Icons.play_arrow,
                    'Start',
                    bed.status != BedStatus.running,
                    () {
                      // You can handle quick actions here
                    },
                  ),
                  _buildQuickButton(
                    Icons.stop,
                    'Stop',
                    bed.status == BedStatus.running,
                    () {},
                  ),
                  _buildQuickButton(Icons.water_drop, 'Water', true, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorItem(IconData icon, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMachineIcon(IconData icon, bool isActive, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 14,
          color: isActive ? AppColors.success : AppColors.textSecondary,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: isActive ? AppColors.success : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickButton(
    IconData icon,
    String label,
    bool enabled,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: enabled ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: enabled ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (bed.status) {
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
}
