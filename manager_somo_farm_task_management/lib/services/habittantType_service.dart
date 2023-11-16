import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class HabitantTypeService {
  Future<List<Map<String, dynamic>>> getPlantTypeFromHabitantType(
      int id) async {
    final String getPlantTypeUrl =
        '$baseUrl/HabitantType/PlantType/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getPlantTypeUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> plants =
          List<Map<String, dynamic>>.from(data['data']);
      return plants;
    } else {
      throw Exception('Failed to get plant type from habitant type');
    }
  }

  Future<List<Map<String, dynamic>>> getLiveStockTypeFromHabitantType(
      int id) async {
    final String getLLiveStockUrl =
        '$baseUrl/HabitantType/LivestockType/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getLLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> liveStocks =
          List<Map<String, dynamic>>.from(data['data']);
      return liveStocks;
    } else {
      throw Exception('Failed to get plant type from habitant type');
    }
  }

  Future<bool> CreateHabitantType(Map<String, dynamic> habitantType) async {
    final String createHabitantTypekUrl = '$baseUrl/HabitantType';
    var body = jsonEncode(habitantType);
    final response = await http.post(Uri.parse(createHabitantTypekUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create habitant type');
    }
  }

  Future<bool> UpdateHabitantType(
      Map<String, dynamic> habitantType, int id) async {
    final String updateHabitantTypeUrl = '$baseUrl/HabitantType/${id}';
    var body = jsonEncode(habitantType);
    final response = await http.put(Uri.parse(updateHabitantTypeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
