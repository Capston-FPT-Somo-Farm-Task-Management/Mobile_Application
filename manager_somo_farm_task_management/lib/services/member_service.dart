import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class MemberService {
  Future<List<Map<String, dynamic>>> getSupervisorsbyFarmId(int farmId) async {
    final String getSupervisorsUrl =
        '$baseUrl/Member/Supervisor/Farm(${farmId})';

    final http.Response response = await http.get(
      Uri.parse(getSupervisorsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> supervisors =
          List<Map<String, dynamic>>.from(data['data']);
      return supervisors;
    } else {
      throw Exception('Failed to get supervisors');
    }
  }

  Future<List<Map<String, dynamic>>> getSupervisorsActivebyFarmId(
      int farmId) async {
    final String getSupervisorsUrl =
        '$baseUrl/Member/Active/Supervisor/Farm(${farmId})';

    final http.Response response = await http.get(
      Uri.parse(getSupervisorsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> supervisors =
          List<Map<String, dynamic>>.from(data['data']);
      return supervisors;
    } else {
      throw Exception('Failed to get supervisors');
    }
  }

  Future<bool> createMember(Map<String, dynamic> data) async {
    final String apiUrl = "$baseUrl/Member";
    var body = jsonEncode(data);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
