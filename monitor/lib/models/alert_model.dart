enum AlertType { danger, warning, success, info, system }

class AlertModel {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String bedId;
  final String? actionTaken;
  final bool? requiresAction;

  const AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.bedId,
    this.actionTaken,
    this.requiresAction = false,
  });

  AlertModel copyWith({
    String? id,
    AlertType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? bedId,
    String? actionTaken,
    bool? requiresAction,
  }) {
    return AlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      bedId: bedId ?? this.bedId,
      actionTaken: actionTaken ?? this.actionTaken,
      requiresAction: requiresAction ?? this.requiresAction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'bedId': bedId,
      'actionTaken': actionTaken,
      'requiresAction': requiresAction,
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      type: AlertType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AlertType.info,
      ),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      isRead: json['isRead'] ?? false,
      bedId: json['bedId'] ?? '',
      actionTaken: json['actionTaken'],
      requiresAction: json['requiresAction'] ?? false,
    );
  }
}
