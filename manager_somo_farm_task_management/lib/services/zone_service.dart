import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class ZoneService {
  Future<List<Map<String, dynamic>>> getZonesbyAreaId(int areaId) async {
    final String getZonesUrl = '$baseUrl/Zone/Area($areaId)';

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
      throw Exception('Failed to get zones by area ID');
    }
  }
}
