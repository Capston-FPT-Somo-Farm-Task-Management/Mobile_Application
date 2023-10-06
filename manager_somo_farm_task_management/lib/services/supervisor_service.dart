import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class SupervisorService {
  Future<List<Map<String, dynamic>>> getSupervisorsbyFarmId(int farmId) async {
    final String getEmsUrl = '$baseUrl/Member/Supervisor/Farm($farmId)';

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
      throw Exception('Failed to get supervisors by farm ID');
    }
  }

  Future<bool> createSupervisor(Map<String, dynamic> supervisorData) async {
    final String apiUrl = "$baseUrl/Employee";
    var body = jsonEncode(supervisorData);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Failed to create supervisor");
    }
  }
}
