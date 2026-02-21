class FarmerProfile {
  final String name;
  final String phone;
  final String email;
  final String location;
  final String bedSize;
  final String wormCount;
  final int compostCycles;
  final DateTime joinDate;
  final bool notificationsEnabled;
  final bool autoModeEnabled;
  final String language;
  final String themeMode;

  const FarmerProfile({
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.bedSize,
    required this.wormCount,
    required this.compostCycles,
    required this.joinDate,
    required this.notificationsEnabled,
    required this.autoModeEnabled,
    required this.language,
    required this.themeMode,
  });

  FarmerProfile copyWith({
    String? name,
    String? phone,
    String? email,
    String? location,
    String? bedSize,
    String? wormCount,
    int? compostCycles,
    DateTime? joinDate,
    bool? notificationsEnabled,
    bool? autoModeEnabled,
    String? language,
    String? themeMode,
  }) {
    return FarmerProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      bedSize: bedSize ?? this.bedSize,
      wormCount: wormCount ?? this.wormCount,
      compostCycles: compostCycles ?? this.compostCycles,
      joinDate: joinDate ?? this.joinDate,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoModeEnabled: autoModeEnabled ?? this.autoModeEnabled,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'bedSize': bedSize,
      'wormCount': wormCount,
      'compostCycles': compostCycles,
      'joinDate': joinDate.toIso8601String(),
      'notificationsEnabled': notificationsEnabled,
      'autoModeEnabled': autoModeEnabled,
      'language': language,
      'themeMode': themeMode,
    };
  }

  factory FarmerProfile.fromJson(Map<String, dynamic> json) {
    return FarmerProfile(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      bedSize: json['bedSize'] ?? '',
      wormCount: json['wormCount'] ?? '',
      compostCycles: json['compostCycles'] ?? 0,
      joinDate: DateTime.parse(
        json['joinDate'] ?? DateTime.now().toIso8601String(),
      ),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      autoModeEnabled: json['autoModeEnabled'] ?? true,
      language: json['language'] ?? 'English',
      themeMode: json['themeMode'] ?? 'Light',
    );
  }
}
