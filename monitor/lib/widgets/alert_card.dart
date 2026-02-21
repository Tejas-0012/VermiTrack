import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';

class AlertCard extends StatelessWidget {
  final String type; // 'danger', 'warning', 'success', 'info', 'system'
  final String title;
  final String message;
  final String time;
  final String? bedId;
  final String? actionTaken;
  final bool? requiresAction;
  final bool isRead;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.bedId,
    this.actionTaken,
    this.requiresAction = false,
    this.isRead = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color iconColor;
    Color borderColor;
    IconData icon;

    switch (type) {
      case 'danger':
        backgroundColor = AppColors.danger.withOpacity(0.1);
        iconColor = AppColors.danger;
        borderColor = AppColors.danger.withOpacity(0.2);
        icon = Icons.error;
        break;
      case 'warning':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        iconColor = AppColors.warning;
        borderColor = AppColors.warning.withOpacity(0.2);
        icon = Icons.warning;
        break;
      case 'success':
        backgroundColor = AppColors.success.withOpacity(0.1);
        iconColor = AppColors.success;
        borderColor = AppColors.success.withOpacity(0.2);
        icon = Icons.check_circle;
        break;
      case 'system':
        backgroundColor = AppColors.info.withOpacity(0.1);
        iconColor = AppColors.info;
        borderColor = AppColors.info.withOpacity(0.2);
        icon = Icons.devices;
        break;
      case 'info':
      default:
        backgroundColor = AppColors.info.withOpacity(0.1);
        iconColor = AppColors.info;
        borderColor = AppColors.info.withOpacity(0.2);
        icon = Icons.info;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? borderColor.withOpacity(0.5) : borderColor,
            width: isRead ? 1 : 2,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Unread Indicator
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: iconColor,
                                ),
                              ),
                            ),
                            if (!isRead)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Message
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Metadata
                        Row(
                          children: [
                            // Time
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Bed ID
                            if (bedId != null) ...[
                              Icon(
                                Icons.bed,
                                size: 12,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                bedId!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],

                            const Spacer(),

                            // Action Taken Badge
                            if (actionTaken != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Action Taken',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Requires Action Button
                        if (requiresAction == true && !isRead) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Action Required',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
