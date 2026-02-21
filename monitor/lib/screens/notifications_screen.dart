import 'package:flutter/material.dart';
import 'package:monitor/utils/colors.dart';
import 'package:monitor/models/alert_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Critical', 'System'];

  List<AlertModel> _notifications = [
    AlertModel(
      id: '1',
      type: AlertType.warning,
      title: 'Low Moisture',
      message: 'Moisture dropped to 58%. Auto watering activated.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      bedId: 'Bed 1',
      actionTaken: 'Auto watering',
    ),
    AlertModel(
      id: '2',
      type: AlertType.info,
      title: 'Temp Check',
      message: 'Optimal at 28.5°C. No action needed.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      bedId: 'Bed 1',
    ),
    AlertModel(
      id: '3',
      type: AlertType.success,
      title: 'pH Stable',
      message: 'pH at 7.2 for last 24h.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      bedId: 'All',
    ),
    AlertModel(
      id: '4',
      type: AlertType.danger,
      title: 'High Temp!',
      message: '35.2°C in Bed 2. Check ventilation.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: false,
      bedId: 'Bed 2',
      requiresAction: true,
    ),
    AlertModel(
      id: '5',
      type: AlertType.warning,
      title: 'Watering Done',
      message: 'Watered Bed 1 for 20s. +8% moisture.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      bedId: 'Bed 1',
      actionTaken: 'Manual',
    ),
    AlertModel(
      id: '6',
      type: AlertType.system,
      title: 'Device Offline',
      message: 'ESP32 disconnected. Reconnecting...',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      isRead: true,
      bedId: 'System',
    ),
    AlertModel(
      id: '7',
      type: AlertType.info,
      title: 'Daily Summary',
      message: 'All parameters optimal.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      bedId: 'All',
    ),
    AlertModel(
      id: '8',
      type: AlertType.warning,
      title: 'Turn Bed',
      message: 'Time to turn bed for aeration.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      bedId: 'Bed 1',
      requiresAction: true,
    ),
  ];

  int get unreadCount {
    return _notifications.where((alert) => !alert.isRead).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _filterNotifications(_selectedFilter);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 22),
                onSelected: _handlePopupMenuSelect,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Icon(Icons.mark_email_read, size: 18),
                        SizedBox(width: 8),
                        Text('Mark all read'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18),
                        SizedBox(width: 8),
                        Text('Clear all'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    final count = _getFilterCount(filter);

                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Row(
                          children: [
                            Text(filter, style: TextStyle(fontSize: 13)),
                            if (count > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  count > 9 ? '9+' : count.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Notifications List
          if (filteredNotifications.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 60,
                      color: AppColors.textSecondary.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFilter == 'All'
                          ? 'You\'re all caught up'
                          : 'No ${_selectedFilter.toLowerCase()} notifications',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshNotifications,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 18),
                          const SizedBox(width: 6),
                          Text('Refresh', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final notification = filteredNotifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Dismissible(
                      key: Key(notification.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      onDismissed: (direction) {
                        _deleteNotification(notification.id);
                      },
                      confirmDismiss: (direction) async {
                        return await _confirmDelete(notification);
                      },
                      child: GestureDetector(
                        onTap: () {
                          _markAsRead(notification.id);
                          _showNotificationDetails(notification);
                        },
                        child: Container(
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
                            children: [
                              Container(
                                width: 4,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: _getAlertColor(notification.type),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            _getAlertIcon(notification.type),
                                            size: 16,
                                            color: _getAlertColor(
                                              notification.type,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              notification.title,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (!notification.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notification.message,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _formatTimeAgo(
                                              notification.timestamp,
                                            ),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.bed,
                                            size: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            notification.bedId,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textSecondary,
                                            ),
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
                      ),
                    ),
                  );
                }, childCount: filteredNotifications.length),
              ),
            ),
        ],
      ),
    );
  }

  // Helper Methods
  List<AlertModel> _filterNotifications(String filter) {
    switch (filter) {
      case 'Unread':
        return _notifications.where((alert) => !alert.isRead).toList();
      case 'Critical':
        return _notifications
            .where((alert) => alert.type == AlertType.danger)
            .toList();
      case 'System':
        return _notifications
            .where((alert) => alert.type == AlertType.system)
            .toList();
      default:
        return _notifications;
    }
  }

  int _getFilterCount(String filter) {
    switch (filter) {
      case 'Unread':
        return unreadCount;
      case 'Critical':
        return _notifications
            .where((alert) => alert.type == AlertType.danger)
            .length;
      case 'System':
        return _notifications
            .where((alert) => alert.type == AlertType.system)
            .length;
      default:
        return _notifications.length;
    }
  }

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.danger:
        return AppColors.danger;
      case AlertType.warning:
        return AppColors.warning;
      case AlertType.success:
        return AppColors.success;
      case AlertType.system:
        return AppColors.info;
      default:
        return AppColors.info;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.danger:
        return Icons.error;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.system:
        return Icons.devices;
      default:
        return Icons.info;
    }
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${timestamp.day}/${timestamp.month}';
  }

  // Action Methods
  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (_notifications.isNotEmpty) {
        _notifications[0] = _notifications[0].copyWith(isRead: false);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Refreshed'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications.map((alert) {
        if (alert.id == id) {
          return alert.copyWith(isRead: true);
        }
        return alert;
      }).toList();
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications
          .map((alert) => alert.copyWith(isRead: true))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All marked read'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((alert) => alert.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Deleted'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All cleared'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  Future<bool> _confirmDelete(AlertModel alert) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete?'),
            content: Text('Delete "${alert.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ) ??
        false;
  }

  void _showNotificationDetails(AlertModel notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getAlertIcon(notification.type),
                  color: _getAlertColor(notification.type),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notification.message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  _formatTimeAgo(notification.timestamp),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.bed, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  notification.bedId,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (notification.actionTaken != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.play_arrow, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Action: ${notification.actionTaken}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (notification.requiresAction == true) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Take Action'),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _handlePopupMenuSelect(String value) {
    switch (value) {
      case 'mark_all_read':
        _markAllAsRead();
        break;
      case 'clear_all':
        _showClearAllConfirmation();
        break;
    }
  }

  void _showClearAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllNotifications();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
