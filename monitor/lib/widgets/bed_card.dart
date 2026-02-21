import 'package:flutter/material.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/utils/colors.dart';

class BedCard extends StatelessWidget {
  final BedModel bed;
  final VoidCallback onTap;

  const BedCard({super.key, required this.bed, required this.onTap});

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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      bed.status.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                    // Layer progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Layer',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${bed.currentLayer}/${bed.totalLayers}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Temperature
                    Row(
                      children: [
                        Icon(
                          Icons.thermostat,
                          size: 14,
                          color: _getTempColor(bed.temperature),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bed.temperature.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getTempColor(bed.temperature),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.water_drop,
                          size: 14,
                          color: _getMoistureColor(bed.moisture),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bed.moisture.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getMoistureColor(bed.moisture),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // pH and Day
                    Row(
                      children: [
                        Icon(
                          Icons.science,
                          size: 14,
                          color: _getPHColor(bed.ph),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'pH ${bed.ph.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _getPHColor(bed.ph),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Day ${bed.compostDay}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 12),

                    // Machine status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMachineIcon(
                          Icons.sensors,
                          bed.conveyorRunning,
                          'Conveyor',
                        ),
                        _buildMachineIcon(
                          Icons.autorenew,
                          bed.mixerRunning,
                          'Mixer',
                        ),
                        _buildMachineIcon(
                          Icons.door_sliding,
                          bed.gateStatus == GateStatus.open,
                          'Gate',
                          color: bed.gateStatus == GateStatus.open
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineIcon(
    IconData icon,
    bool isActive,
    String label, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color:
              color ?? (isActive ? AppColors.success : AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
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
