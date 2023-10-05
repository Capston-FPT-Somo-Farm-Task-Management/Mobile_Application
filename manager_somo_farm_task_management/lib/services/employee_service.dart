import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int farmId, int taskTypeId) async {
    final String getZonesUrl =
        '$baseUrl/Employee/Active/TaskType($taskTypeId)/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> zones =
          List<Map<String, dynamic>>.from(data['data']);
      return zones;
    } else {
      throw Exception('Failed to get fields by zone ID');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesbyFarmId(int farmId) async {
    final String getEmsUrl = '$baseUrl/Employee/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getEmsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      throw Exception('Failed to get ems by farm ID');
    }
  }

  Future<bool> createEmployee(Map<String, dynamic> employeeData) async {
    final String apiUrl = "$baseUrl/Employee";
    var body = jsonEncode(employeeData);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to create employee");
    }
  }

  Future<bool> changeStatusEmployee(int employeeId) async {
    final String url = '$baseUrl/Employee/ChangeStatus/$employeeId';

    final http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to change status');
    }
  }
}
