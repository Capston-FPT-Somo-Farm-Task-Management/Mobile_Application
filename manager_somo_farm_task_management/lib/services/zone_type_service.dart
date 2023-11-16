import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class ZoneTypeService {
  Future<List<Map<String, dynamic>>> getZonesType() async {
    final String getZonesUrl = '$baseUrl/ZoneType';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> zones =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return zones;
    } else {
      throw Exception('Failed to get zoneType');
    }
  }
}
