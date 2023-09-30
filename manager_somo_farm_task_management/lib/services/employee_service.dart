import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int farmId, int taskTypeId) async {
    final String getZonesUrl =
        '$baseUrl/Employee/TaskType($taskTypeId)/Farm($farmId)';

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
}
