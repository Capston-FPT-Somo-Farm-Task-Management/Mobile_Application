import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class PlantService {
  Future<List<Map<String, dynamic>>> getPlantExternalIdsByFieldId(
      int fieldId) async {
    final String getTasksUrl = '$baseUrl/Plant/ExternalId/Field($fieldId)';

    final http.Response response = await http.get(
      Uri.parse(getTasksUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ids =
          List<Map<String, dynamic>>.from(data['data']);
      return ids;
    } else {
      throw Exception('Failed to get Plant ExternalId by user ID');
    }
  }

  Future<List<Map<String, dynamic>>> getAllPlant() async {
    final String getPlantUrl = '$baseUrl/Plant';

    final http.Response response = await http.get(
      Uri.parse(getPlantUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> plants =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return plants;
    } else {
      throw Exception('Failed to get plant');
    }
  }

  Future<Map<String, dynamic>> getPlantById(int id) async {
    final String getLiveStockUrl = '$baseUrl/Plant/&id';

    final http.Response response = await http.get(
      Uri.parse(getLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> plants =
          Map<String, dynamic>.from(json.decode(response.body));
      return plants;
    } else {
      throw Exception('Failed to get plant');
    }
  }

  Future<bool> deletePlant(int id) async {
    final String deletePlantUrl = '$baseUrl/Plant/Delete/${id}';
    final http.Response response =
        await http.put(Uri.parse(deletePlantUrl), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete plant');
    }
  }

  Future<bool> createPlant(Map<String, dynamic> plant) async {
    final String createPlantUrl = '$baseUrl/Plant';
    var body = jsonEncode(plant);
    final response = await http.post(Uri.parse(createPlantUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getPlantByFarmId(int id) async {
    final String getPlantUrl = '$baseUrl/Plant/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getPlantUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> plants =
          List<Map<String, dynamic>>.from(data['data']);
      return plants;
    } else {
      throw Exception('Failed to get plant');
    }
  }

  Future<bool> UpdatePlant(Map<String, dynamic> plant, int id) async {
    final String updatePlantUrl = '$baseUrl/Plant/${id}';
    var body = jsonEncode(plant);
    final response = await http.put(Uri.parse(updatePlantUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
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
