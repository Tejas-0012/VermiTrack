enum BedStatus { idle, running, drying, done, error }

enum GateStatus { open, closed, opening, closing }

enum LayerType { cowDung, dryLeaves, greenWaste, soil, worms }

class BedModel {
  final String id;
  final String name;
  final BedStatus status;
  final double moisture;
  final double temperature;
  final double ph;
  final int currentLayer; // 1-5
  final int totalLayers; // Always 5
  final GateStatus gateStatus;
  final bool conveyorRunning;
  final bool mixerRunning;
  final DateTime lastUpdated;
  final int compostDay;
  final String? errorMessage;

  BedModel({
    required this.id,
    required this.name,
    required this.status,
    required this.moisture,
    required this.temperature,
    required this.ph,
    required this.currentLayer,
    required this.totalLayers,
    required this.gateStatus,
    required this.conveyorRunning,
    required this.mixerRunning,
    required this.lastUpdated,
    required this.compostDay,
    this.errorMessage,
  });

  factory BedModel.fromJson(Map<String, dynamic> json) {
    return BedModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Bed ${json['id']}',
      status: BedStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BedStatus.idle,
      ),
      moisture: (json['moisture'] ?? 0.0).toDouble(),
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      ph: (json['ph'] ?? 7.0).toDouble(),
      currentLayer: json['currentLayer'] ?? 1,
      totalLayers: json['totalLayers'] ?? 5,
      gateStatus: GateStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['gateStatus'],
        orElse: () => GateStatus.closed,
      ),
      conveyorRunning: json['conveyorRunning'] ?? false,
      mixerRunning: json['mixerRunning'] ?? false,
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
      compostDay: json['compostDay'] ?? 1,
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.toString().split('.').last,
      'moisture': moisture,
      'temperature': temperature,
      'ph': ph,
      'currentLayer': currentLayer,
      'totalLayers': totalLayers,
      'gateStatus': gateStatus.toString().split('.').last,
      'conveyorRunning': conveyorRunning,
      'mixerRunning': mixerRunning,
      'lastUpdated': lastUpdated.toIso8601String(),
      'compostDay': compostDay,
      'errorMessage': errorMessage,
    };
  }

  BedModel copyWith({
    String? id,
    String? name,
    BedStatus? status,
    double? moisture,
    double? temperature,
    double? ph,
    int? currentLayer,
    int? totalLayers,
    GateStatus? gateStatus,
    bool? conveyorRunning,
    bool? mixerRunning,
    DateTime? lastUpdated,
    int? compostDay,
    String? errorMessage,
  }) {
    return BedModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      moisture: moisture ?? this.moisture,
      temperature: temperature ?? this.temperature,
      ph: ph ?? this.ph,
      currentLayer: currentLayer ?? this.currentLayer,
      totalLayers: totalLayers ?? this.totalLayers,
      gateStatus: gateStatus ?? this.gateStatus,
      conveyorRunning: conveyorRunning ?? this.conveyorRunning,
      mixerRunning: mixerRunning ?? this.mixerRunning,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      compostDay: compostDay ?? this.compostDay,
      errorMessage: errorMessage,
    );
  }
}
