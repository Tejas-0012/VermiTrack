import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';

class SettingTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String type; // 'toggle', 'select', 'navigate', 'action'
  final dynamic value;
  final List<String>? options;
  final Function(dynamic)? onChanged;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.type,
    this.value,
    this.options,
    this.onChanged,
    this.onTap,
    this.showDivider = true,
  });

  @override
  State<SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<SettingTile> {
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: widget.type == 'navigate' || widget.type == 'action'
              ? widget.onTap
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildTrailingWidget(),
              ],
            ),
          ),
        ),
        if (widget.showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: AppColors.border, height: 1),
          ),
      ],
    );
  }

  Widget _buildTrailingWidget() {
    switch (widget.type) {
      case 'toggle':
        return Switch(
          value: _currentValue as bool,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
            widget.onChanged?.call(value);
          },
          activeThumbColor: AppColors.primary,
        );

      case 'select':
        return Row(
          children: [
            Text(
              _currentValue.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        );

      case 'navigate':
        return const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
          size: 24,
        );

      case 'action':
        return IconButton(
          icon: const Icon(
            Icons.open_in_new,
            color: AppColors.primary,
            size: 20,
          ),
          onPressed: widget.onTap,
        );

      default:
        return const SizedBox();
    }
  }
}
