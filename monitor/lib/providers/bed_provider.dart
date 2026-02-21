import 'package:flutter/material.dart';
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/models/command_model.dart'; // Add this import
import 'package:monitor/services/api_service.dart';

class BedProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<BedModel> _beds = [];
  BedModel? _selectedBed;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BedModel> get beds => _beds;
  BedModel? get selectedBed => _selectedBed;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Statistics
  int get totalBeds => _beds.length;
  int get runningBeds =>
      _beds.where((b) => b.status == BedStatus.running).length;
  int get dryingBeds => _beds.where((b) => b.status == BedStatus.drying).length;
  int get doneBeds => _beds.where((b) => b.status == BedStatus.done).length;
  int get errorBeds => _beds.where((b) => b.status == BedStatus.error).length;

  // Fetch all beds
  Future<void> fetchAllBeds() async {
    _setLoading(true);
    try {
      final beds = await _apiService.getAllBeds();
      _beds = beds;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Fetch single bed
  Future<void> fetchBed(String bedId) async {
    _setLoading(true);
    try {
      final bed = await _apiService.getBed(bedId);
      final index = _beds.indexWhere((b) => b.id == bedId);
      if (index >= 0) {
        _beds[index] = bed;
      } else {
        _beds.add(bed);
      }
      if (_selectedBed?.id == bedId) {
        _selectedBed = bed;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Select bed
  void selectBed(String bedId) {
    _selectedBed = _beds.firstWhere(
      (b) => b.id == bedId,
      orElse: () => throw Exception('Bed not found'),
    );
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedBed = null;
    notifyListeners();
  }

  // Send command to bed
  Future<void> sendCommand(
    String bedId,
    String command, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _apiService.sendCommand(bedId, command, parameters: parameters);
      // Refresh bed after command
      await fetchBed(bedId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  // Start process for bed
  Future<void> startProcess(String bedId) async {
    await sendCommand(bedId, 'start_process');
  }

  // Stop process
  Future<void> stopProcess(String bedId) async {
    await sendCommand(bedId, 'stop_process');
  }

  // Emergency stop
  Future<void> emergencyStop(String bedId) async {
    await sendCommand(bedId, 'emergency_stop');
  }

  // Open gate
  Future<void> openGate(String bedId) async {
    await sendCommand(bedId, 'open_gate');
  }

  // Close gate
  Future<void> closeGate(String bedId) async {
    await sendCommand(bedId, 'close_gate');
  }

  // Start conveyor
  Future<void> startConveyor(String bedId, {int? durationSeconds}) async {
    await sendCommand(
      bedId,
      'start_conveyor',
      parameters: durationSeconds != null
          ? {'duration': durationSeconds}
          : null,
    );
  }

  // Stop conveyor
  Future<void> stopConveyor(String bedId) async {
    await sendCommand(bedId, 'stop_conveyor');
  }

  // Start mixer
  Future<void> startMixer(String bedId, {int? durationSeconds}) async {
    await sendCommand(
      bedId,
      'start_mixer',
      parameters: durationSeconds != null
          ? {'duration': durationSeconds}
          : null,
    );
  }

  // Stop mixer
  Future<void> stopMixer(String bedId) async {
    await sendCommand(bedId, 'stop_mixer');
  }

  // Next layer
  Future<void> nextLayer(String bedId) async {
    await sendCommand(bedId, 'next_layer');
  }

  // Previous layer
  Future<void> previousLayer(String bedId) async {
    await sendCommand(bedId, 'previous_layer');
  }

  // Set auto mode
  Future<void> setAutoMode(String bedId, bool enabled) async {
    await sendCommand(bedId, enabled ? 'auto_mode_on' : 'auto_mode_off');
  }

  // Reset bed
  Future<void> resetBed(String bedId) async {
    await sendCommand(bedId, 'reset_bed');
  }

  // Refresh all beds
  Future<void> refreshAllBeds() async {
    await fetchAllBeds();
  }

  // ===== NEW METHOD ADDED HERE =====
  // Get command history for a bed
  Future<List<CommandModel>> getBedCommandHistory(String bedId) async {
    try {
      return await _apiService.getBedCommandHistory(bedId);
    } catch (e) {
      print('Error fetching command history: $e');
      return [];
    }
  }
  // ===== END OF NEW METHOD =====

  // Emergency stop all beds
  Future<void> emergencyStopAll() async {
    try {
      await _apiService.emergencyStopAll();
      await refreshAllBeds();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
