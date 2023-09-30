import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class MaterialService {
  Future<List<Map<String, dynamic>>> getMaterial() async {
    final String getMaterialsUrl = '$baseUrl/Material';

    final http.Response response = await http.get(
      Uri.parse(getMaterialsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> materials =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return materials;
    } else {
      throw Exception('Failed to get materials');
    }
  }
}
