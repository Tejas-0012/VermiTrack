class AppConstants {
  // API Endpoints
  static const String baseUrl = 'http://10.221.49.187:5000';
  static const String apiEndpoint = '$baseUrl/api';

  // App Info
  static const String appName = 'Smart Vermi Compost';
  static const String appVersion = '2.0.0';
  static const String appBuildNumber = '2';

  // Compost Settings
  static const double minMoisture = 55.0;
  static const double maxMoisture = 70.0;
  static const double minTemperature = 25.0;
  static const double maxTemperature = 35.0;
  static const double minPH = 6.5;
  static const double maxPH = 7.5;
  static const int totalCompostDays = 45;
  static const int totalLayers = 5;

  // Machine Settings
  static const int conveyorDefaultDuration = 30; // seconds
  static const int mixerDefaultDuration = 20; // seconds
  static const int gateOpenTimeout = 10; // seconds
  static const int autoRefreshInterval = 5000; // milliseconds

  // Bed Status Colors
  static const Map<String, String> bedStatusColors = {
    'idle': '#9E9E9E',
    'running': '#4CAF50',
    'drying': '#FF9800',
    'done': '#2196F3',
    'error': '#F44336',
  };

  // Command Labels
  static const Map<String, String> commandLabels = {
    'start_process': 'Start Process',
    'stop_process': 'Stop',
    'emergency_stop': 'EMERGENCY STOP',
    'open_gate': 'Open Gate',
    'close_gate': 'Close Gate',
    'start_conveyor': 'Start Conveyor',
    'stop_conveyor': 'Stop Conveyor',
    'start_mixer': 'Start Mixer',
    'stop_mixer': 'Stop Mixer',
    'next_layer': 'Next Layer',
    'previous_layer': 'Previous Layer',
    'reset_bed': 'Reset Bed',
    'auto_mode_on': 'Auto Mode ON',
    'auto_mode_off': 'Auto Mode OFF',
  };

  // Storage Keys
  static const String storageUserKey = 'user_data';
  static const String storageSettingsKey = 'app_settings';
  static const String storageBedsKey = 'beds_data';
  static const String storageSelectedBedKey = 'selected_bed';

  // Quick Actions
  static const List<Map<String, dynamic>> quickActions = [
    {'label': 'Start All', 'icon': 'play_arrow', 'command': 'start_all'},
    {'label': 'Stop All', 'icon': 'stop', 'command': 'stop_all'},
    {
      'label': 'Emergency',
      'icon': 'warning',
      'command': 'emergency',
      'color': 'danger',
    },
    {'label': 'Refresh', 'icon': 'refresh', 'command': 'refresh'},
  ];
}

class ApiEndpoints {
  static const String beds = '/beds';
  static const String sensors = '/sensors';
  static const String commands = '/commands';
  static const String system = '/system';

  static String getBed(String bedId) => '$beds/$bedId';
  static String getBedCommands(String bedId) => '$beds/$bedId/commands';
  static String getBedSensors(String bedId) => '$sensors/$bedId';
  static String getBedLatestSensor(String bedId) => '$sensors/$bedId/latest';
  static String getBedHistory(String bedId) => '$sensors/$bedId/history';
}
