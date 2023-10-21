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
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getAreasActiveByFarmId(int farmId) async {
    final String getAreasUrl = '$baseUrl/Area/Active/Farm($farmId)';

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
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createArea(Map<String, dynamic> areaData) async {
    final String apiUrl = "$baseUrl/Area";
    var body = jsonEncode(areaData);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> changeStatusArea(int areaId) async {
    final String url = '$baseUrl/Area/Delete/$areaId';

    final http.Response response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> UpdateArea(Map<String, dynamic> area, int id) async {
    final String updateAreaUrl = '$baseUrl/Area/${id}';
    var body = jsonEncode(area);
    final response = await http.put(Uri.parse(updateAreaUrl),
        headers: {
          'Content-Type': 'application/json',
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
