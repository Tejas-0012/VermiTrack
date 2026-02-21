import 'package:flutter/material.dart';

class CompostProvider with ChangeNotifier {
  int _compostAge = 15;
  final int _totalDays = 45;
  final String _currentPhase = 'Active Composting';
  int _healthScore = 85;

  // Getters
  int get compostAge => _compostAge;
  int get totalDays => _totalDays;
  String get currentPhase => _currentPhase;
  int get healthScore => _healthScore;
  double get progress => _compostAge / _totalDays;

  // Setters
  void updateCompostAge(int age) {
    _compostAge = age;
    notifyListeners();
  }

  void updateHealthScore(int score) {
    _healthScore = score;
    notifyListeners();
  }

  void nextDay() {
    if (_compostAge < _totalDays) {
      _compostAge++;
      notifyListeners();
    }
  }
}
