class SensorData {
  final double temperature;
  final double moisture;
  final double ph;
  // final double oxygen;
  final String healthStatus;
  final DateTime lastUpdated;
  final int? compostDay;

  SensorData({
    required this.temperature,
    required this.moisture,
    required this.ph,
    // required this.oxygen,
    required this.healthStatus,
    required this.lastUpdated,
    this.compostDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'moisture': moisture,
      'ph': ph,
      // 'oxygen': oxygen,
      'healthStatus': healthStatus,
      'lastUpdated': lastUpdated.toIso8601String(),
      'compostDay': compostDay,
    };
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature'] ?? 0.0,
      moisture: json['moisture'] ?? 0.0,
      ph: json['ph'] ?? 0.0,
      // oxygen: json['oxygen'] ?? 0.0,
      healthStatus: json['healthStatus'] ?? 'Unknown',
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
      compostDay: json['compostDay'],
    );
  }
}
