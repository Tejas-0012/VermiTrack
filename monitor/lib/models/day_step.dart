class DayStep {
  final int day;
  final String title;
  final String description;
  final String? imageUrl;
  final String duration;
  final List<String>? materials;
  final String? tip;
  final String? warning;

  const DayStep({
    required this.day,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.duration,
    this.materials,
    this.tip,
    this.warning,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'materials': materials,
      'tip': tip,
      'warning': warning,
    };
  }

  factory DayStep.fromJson(Map<String, dynamic> json) {
    return DayStep(
      day: json['day'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
      duration: json['duration'] ?? '',
      materials: json['materials'] != null
          ? List<String>.from(json['materials'])
          : null,
      tip: json['tip'],
      warning: json['warning'],
    );
  }
}
