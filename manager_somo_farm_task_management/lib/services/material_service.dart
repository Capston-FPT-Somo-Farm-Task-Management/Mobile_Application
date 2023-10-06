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
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> materials =
          List<Map<String, dynamic>>.from(data['data']);
      return materials;
    } else {
      throw Exception('Failed to get materials');
    }
  }

  Future<List<Map<String, dynamic>>> getMaterialActive() async {
    final String getMaterialsUrl = '$baseUrl/Material/Active';

    final http.Response response = await http.get(
      Uri.parse(getMaterialsUrl),
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
      throw Exception('Failed to get materials');
    }
  }
}
