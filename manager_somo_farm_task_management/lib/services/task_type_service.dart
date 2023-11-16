import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class TaskTypeService {
  Future<List<Map<String, dynamic>>> getTaskTypePlants() async {
    final String getZonesUrl = '$baseUrl/TaskType/ListTaskTypePlant';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> listTaskTypePlants =
          List<Map<String, dynamic>>.from(data['data']);
      return listTaskTypePlants;
    } else {
      throw Exception('Failed to get list TaskTypePlants');
    }
  }

  Future<List<Map<String, dynamic>>> getListTaskTypeLivestock() async {
    final String getZonesUrl = '$baseUrl/TaskType/ListTaskTypeLivestock';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> listTaskTypeLivestocks =
          List<Map<String, dynamic>>.from(data['data']);
      return listTaskTypeLivestocks;
    } else {
      throw Exception('Failed to get list TaskTypeLivestock');
    }
  }

  Future<List<Map<String, dynamic>>> getListTaskTypeActive() async {
    final String getZonesUrl = '$baseUrl/TaskType/Active';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> listTaskTypeLivestocks =
          List<Map<String, dynamic>>.from(data['data']);
      return listTaskTypeLivestocks;
    } else {
      throw Exception('Failed to get list TaskTypeActive');
    }
  }
}
