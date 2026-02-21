enum LayerMaterial {
  cowDung,
  dryLeaves,
  greenWaste,
  soil,
  worms,
  cocopeat,
  vegetableScraps,
}

class LayerStep {
  final int layerNumber;
  final LayerMaterial material;
  final double quantity; // in kg or liters
  final int durationSeconds; // how long conveyor runs
  final bool requiresMixing;
  final int mixDurationSeconds;
  final String description;

  const LayerStep({
    required this.layerNumber,
    required this.material,
    required this.quantity,
    required this.durationSeconds,
    this.requiresMixing = true,
    this.mixDurationSeconds = 30,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'layerNumber': layerNumber,
      'material': material.toString().split('.').last,
      'quantity': quantity,
      'durationSeconds': durationSeconds,
      'requiresMixing': requiresMixing,
      'mixDurationSeconds': mixDurationSeconds,
      'description': description,
    };
  }

  factory LayerStep.fromJson(Map<String, dynamic> json) {
    return LayerStep(
      layerNumber: json['layerNumber'] ?? 1,
      material: LayerMaterial.values.firstWhere(
        (e) => e.toString().split('.').last == json['material'],
        orElse: () => LayerMaterial.cowDung,
      ),
      quantity: (json['quantity'] ?? 1.0).toDouble(),
      durationSeconds: json['durationSeconds'] ?? 20,
      requiresMixing: json['requiresMixing'] ?? true,
      mixDurationSeconds: json['mixDurationSeconds'] ?? 30,
      description: json['description'] ?? '',
    );
  }
}

class LayerSequence {
  final String id;
  final String name;
  final List<LayerStep> steps;
  final bool isActive;
  final DateTime? lastRun;
  final int repeatCount;

  const LayerSequence({
    required this.id,
    required this.name,
    required this.steps,
    this.isActive = false,
    this.lastRun,
    this.repeatCount = 0,
  });

  // Predefined 5-layer vermicompost sequence
  static const LayerSequence defaultSequence = LayerSequence(
    id: 'default_5_layer',
    name: 'Standard 5-Layer Vermicompost',
    steps: [
      LayerStep(
        layerNumber: 1,
        material: LayerMaterial.cowDung,
        quantity: 5.0,
        durationSeconds: 30,
        description: 'Base layer - Pre-decayed cow dung',
      ),
      LayerStep(
        layerNumber: 2,
        material: LayerMaterial.dryLeaves,
        quantity: 3.0,
        durationSeconds: 25,
        description: 'Second layer - Dry leaves for aeration',
      ),
      LayerStep(
        layerNumber: 3,
        material: LayerMaterial.greenWaste,
        quantity: 4.0,
        durationSeconds: 28,
        description: 'Third layer - Green vegetable waste',
      ),
      LayerStep(
        layerNumber: 4,
        material: LayerMaterial.cocopeat,
        quantity: 2.0,
        durationSeconds: 20,
        description: 'Fourth layer - Cocopeat for moisture',
      ),
      LayerStep(
        layerNumber: 5,
        material: LayerMaterial.worms,
        quantity: 0.5,
        durationSeconds: 15,
        requiresMixing: false,
        description: 'Top layer - Earthworms introduced',
      ),
    ],
    isActive: false,
    lastRun: null,
    repeatCount: 0,
  );
}
