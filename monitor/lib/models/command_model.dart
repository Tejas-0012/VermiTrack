enum CommandType {
  startProcess,
  stopProcess,
  emergencyStop,
  openGate,
  closeGate,
  startConveyor,
  stopConveyor,
  startMixer,
  stopMixer,
  nextLayer,
  previousLayer,
  resetBed,
  autoModeOn,
  autoModeOff,
  calibrate,
}

enum CommandSource { user, autoScheduler, emergency, system }

class CommandModel {
  final String id;
  final CommandType type;
  final String bedId;
  final CommandSource source;
  final DateTime timestamp;
  final Map<String, dynamic>? parameters;
  final bool requiresAck;
  final bool isExecuted;
  final DateTime? executedAt;
  final String? resultMessage;

  CommandModel({
    required this.id,
    required this.type,
    required this.bedId,
    required this.source,
    required this.timestamp,
    this.parameters,
    this.requiresAck = true,
    this.isExecuted = false,
    this.executedAt,
    this.resultMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'bedId': bedId,
      'source': source.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'parameters': parameters,
      'requiresAck': requiresAck,
      'isExecuted': isExecuted,
      'executedAt': executedAt?.toIso8601String(),
      'resultMessage': resultMessage,
    };
  }

  factory CommandModel.fromJson(Map<String, dynamic> json) {
    return CommandModel(
      id: json['id'] ?? '',
      type: CommandType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CommandType.stopProcess,
      ),
      bedId: json['bedId'] ?? '',
      source: CommandSource.values.firstWhere(
        (e) => e.toString().split('.').last == json['source'],
        orElse: () => CommandSource.user,
      ),
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      parameters: json['parameters'],
      requiresAck: json['requiresAck'] ?? true,
      isExecuted: json['isExecuted'] ?? false,
      executedAt: json['executedAt'] != null
          ? DateTime.parse(json['executedAt'])
          : null,
      resultMessage: json['resultMessage'],
    );
  }
}
