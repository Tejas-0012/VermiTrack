import 'package:flutter/material.dart';
import 'package:monitor/models/sensor_data.dart';

class SensorProvider with ChangeNotifier {
  SensorData _sensorData = SensorData(
    temperature: 28.5,
    moisture: 65.0,
    ph: 7.2,
    // oxygen: 85.0,
    healthStatus: 'Healthy',
    lastUpdated: DateTime.now(),
  );

  bool _isConnected = true;
  bool _isAutoMode = true;
  bool _isPumpActive = false;

  // Getters
  SensorData get sensorData => _sensorData;
  bool get isConnected => _isConnected;
  bool get isAutoMode => _isAutoMode;
  bool get isPumpActive => _isPumpActive;

  // Setters
  void updateSensorData(SensorData newData) {
    _sensorData = newData;
    notifyListeners();
  }

  void setConnection(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  void setAutoMode(bool autoMode) {
    _isAutoMode = autoMode;
    notifyListeners();
  }

  void setPumpActive(bool active) {
    _isPumpActive = active;
    notifyListeners();
  }

  // Simulate data refresh
  void refreshData() {
    _sensorData = SensorData(
      temperature: 28.5 + (DateTime.now().second % 10) - 5,
      moisture: 65.0 + (DateTime.now().second % 20) - 10,
      ph: 7.2 + (DateTime.now().second % 10) * 0.1 - 0.5,
      // oxygen: 85.0 + (DateTime.now().second % 10) - 5,
      healthStatus: DateTime.now().second % 3 == 0 ? 'Warning' : 'Healthy',
      lastUpdated: DateTime.now(),
    );
    notifyListeners();
  }
}
