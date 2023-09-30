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
}
