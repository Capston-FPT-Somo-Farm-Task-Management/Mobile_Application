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
        'Authorization': 'Bearer $accessToken',
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

  Future<List<Map<String, dynamic>>> getZonesActivebyAreaId(int areaId) async {
    final String getZonesUrl = '$baseUrl/Zone/Active/Area($areaId)';

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

  Future<List<Map<String, dynamic>>> getZonesbyAreaLivestockId(
      int areaId) async {
    final String getZonesUrl = '$baseUrl/Zone/AreaLivestock($areaId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
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

  Future<List<Map<String, dynamic>>> getZonesbyAreaPlantId(int areaId) async {
    final String getZonesUrl = '$baseUrl/Zone/AreaPlant($areaId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
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

  Future<List<Map<String, dynamic>>> getZonesbyFarmId(int farmId) async {
    final String getZonesUrl = '$baseUrl/Zone/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> zones =
          List<Map<String, dynamic>>.from(data['data']);
      return zones;
    } else {
      throw Exception('Failed to get zones by farm ID');
    }
  }

  Future<bool> createZone(Map<String, dynamic> zoneData) async {
    final String apiUrl = "$baseUrl/Zone";
    var body = jsonEncode(zoneData);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> changeStatusZone(int zoneId) async {
    final String url = '$baseUrl/Zone/Delete/$zoneId';
    final http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to change status');
    }
  }

  Future<bool> UpdateZone(Map<String, dynamic> zone, int id) async {
    final String updateZoneUrl = '$baseUrl/Zone/${id}';
    var body = jsonEncode(zone);
    final response = await http.put(Uri.parse(updateZoneUrl),
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
