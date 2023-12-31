import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class FieldService {
  Future<List<Map<String, dynamic>>> getFieldsActivebyZoneId(int zoneId) async {
    final String getZonesUrl = '$baseUrl/Field/Active/Zone($zoneId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> zones =
          List<Map<String, dynamic>>.from(data['data']);
      return zones;
    } else {
      throw Exception('Failed to get fields by zone ID');
    }
  }

  Future<bool> CreateField(Map<String, dynamic> field) async {
    final String createField = '$baseUrl/Field';
    var body = jsonEncode(field);
    final response = await http.post(Uri.parse(createField),
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

  Future<List<Map<String, dynamic>>> getPlantFieldByFarmId(int id) async {
    final String getPlantFieldUrl = '$baseUrl/Field/Plant/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getPlantFieldUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> plantFields =
          List<Map<String, dynamic>>.from(data['data']);
      return plantFields;
    } else {
      throw Exception('Failed to get plant in field');
    }
  }

  Future<List<Map<String, dynamic>>> getLiveStockFieldByFarmId(int id) async {
    final String getLivestockFieldUrl = '$baseUrl/Field/Livestock/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getLivestockFieldUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> livestockFields =
          List<Map<String, dynamic>>.from(data['data']);
      return livestockFields;
    } else {
      throw Exception('Failed to get livestock in field');
    }
  }

  Future<Map<String, dynamic>> getFieldById(int id) async {
    final String getFieldUrl = '$baseUrl/Field/&id';

    final http.Response response = await http.get(
      Uri.parse(getFieldUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> field =
          Map<String, dynamic>.from(json.decode(response.body));
      return field;
    } else {
      throw Exception('Failed to get field');
    }
  }

  Future<bool> UpdateField(Map<String, dynamic> field, int id) async {
    final String updateFieldUrl = '$baseUrl/Field/${id}';
    var body = jsonEncode(field);
    final response = await http.put(Uri.parse(updateFieldUrl),
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

  Future<bool> DeleteField(int id) async {
    final String deleteLiveStockUrl = '$baseUrl/Field/Delete/${id}';

    final http.Response response = await http.put(
      Uri.parse(deleteLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
