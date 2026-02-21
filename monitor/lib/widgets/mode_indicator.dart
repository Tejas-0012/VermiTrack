import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';

class ModeIndicator extends StatelessWidget {
  final bool isAutoMode;
  final bool isPumpActive;
  final bool isConnected;

  const ModeIndicator({
    super.key,
    required this.isAutoMode,
    required this.isPumpActive,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIndicator(
            icon: isAutoMode ? Icons.autorenew : Icons.touch_app,
            label: isAutoMode ? 'AUTO' : 'MANUAL',
            color: isAutoMode ? AppColors.success : AppColors.warning,
          ),
          _buildDivider(),
          _buildIndicator(
            icon: Icons.invert_colors,
            label: isPumpActive ? 'PUMP ON' : 'PUMP OFF',
            color: isPumpActive ? AppColors.primary : AppColors.textSecondary,
          ),
          _buildDivider(),
          _buildIndicator(
            icon: Icons.bluetooth,
            label: isConnected ? 'CONNECTED' : 'OFFLINE',
            color: isConnected ? AppColors.success : AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 20,
      color: AppColors.border,
    );
  }
}