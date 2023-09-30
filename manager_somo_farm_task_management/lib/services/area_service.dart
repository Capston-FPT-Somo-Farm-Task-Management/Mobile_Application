import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class AreaService {
  Future<List<Map<String, dynamic>>> getAreasByFarmId(int farmId) async {
    final String getAreasUrl = '$baseUrl/Area/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> areas =
          List<Map<String, dynamic>>.from(data['data']);
      return areas;
    } else {
      throw Exception('Failed to get area by farm ID');
    }
  }
}
