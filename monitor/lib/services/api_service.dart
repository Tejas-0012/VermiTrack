import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monitor/models/bed_model.dart';
import 'package:monitor/models/command_model.dart';
import 'package:monitor/models/sensor_data.dart';
import 'package:monitor/utils/constants.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  // ============= BED ENDPOINTS =============

  // Get all beds
  Future<List<BedModel>> getAllBeds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/beds'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => BedModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load beds: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching beds: $e');
      rethrow;
    }
  }

  // Get single bed
  Future<BedModel> getBed(String bedId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/beds/$bedId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return BedModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load bed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bed $bedId: $e');
      rethrow;
    }
  }

  // Send command to bed
  Future<void> sendCommand(
    String bedId,
    String command, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final commandModel = CommandModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _stringToCommandType(command),
        bedId: bedId,
        source: CommandSource.user,
        timestamp: DateTime.now(),
        parameters: parameters,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/api/beds/$bedId/command'),
        headers: _getHeaders(),
        body: json.encode(commandModel.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send command: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending command to bed $bedId: $e');
      rethrow;
    }
  }

  // Get bed command history
  Future<List<CommandModel>> getBedCommandHistory(String bedId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/beds/$bedId/commands'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => CommandModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load command history');
      }
    } catch (e) {
      print('Error fetching command history: $e');
      rethrow;
    }
  }

  // ============= SENSOR ENDPOINTS =============

  // Get latest sensor data for bed
  Future<SensorData> getLatestSensorData(String bedId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/sensors/$bedId/latest'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return SensorData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      rethrow;
    }
  }

  // Get sensor history for bed
  Future<List<SensorData>> getSensorHistory(
    String bedId, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }
      queryParams['limit'] = limit.toString();

      final uri = Uri.parse(
        '$baseUrl/api/sensors/$bedId/history',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => SensorData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sensor history');
      }
    } catch (e) {
      print('Error fetching sensor history: $e');
      rethrow;
    }
  }

  // ============= PROCESS ENDPOINTS =============

  // Start automated layering process
  Future<void> startLayeringProcess(String bedId) async {
    await sendCommand(bedId, 'start_process');
  }

  // Stop process
  Future<void> stopLayeringProcess(String bedId) async {
    await sendCommand(bedId, 'stop_process');
  }

  // Emergency stop all beds
  Future<void> emergencyStopAll() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/system/emergency-stop'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to trigger emergency stop');
      }
    } catch (e) {
      print('Error triggering emergency stop: $e');
      rethrow;
    }
  }

  // Get system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/system/status'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load system status');
      }
    } catch (e) {
      print('Error fetching system status: $e');
      rethrow;
    }
  }

  // ============= HELPER METHODS =============

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Add auth token here if needed
      // 'Authorization': 'Bearer $token',
    };
  }

  CommandType _stringToCommandType(String command) {
    switch (command) {
      case 'start_process':
        return CommandType.startProcess;
      case 'stop_process':
        return CommandType.stopProcess;
      case 'emergency_stop':
        return CommandType.emergencyStop;
      case 'open_gate':
        return CommandType.openGate;
      case 'close_gate':
        return CommandType.closeGate;
      case 'start_conveyor':
        return CommandType.startConveyor;
      case 'stop_conveyor':
        return CommandType.stopConveyor;
      case 'start_mixer':
        return CommandType.startMixer;
      case 'stop_mixer':
        return CommandType.stopMixer;
      case 'next_layer':
        return CommandType.nextLayer;
      case 'previous_layer':
        return CommandType.previousLayer;
      case 'reset_bed':
        return CommandType.resetBed;
      case 'auto_mode_on':
        return CommandType.autoModeOn;
      case 'auto_mode_off':
        return CommandType.autoModeOff;
      default:
        return CommandType.stopProcess;
    }
  }
}
