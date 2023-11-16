import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class FarmService {
  Future<Map<String, dynamic>> getFarmById(int farmId) async {
    final String getFarmUrl = '$baseUrl/Farm/$farmId';

    final http.Response response = await http.get(
      Uri.parse(getFarmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> farm = Map<String, dynamic>.from(data['data']);
      return farm;
    } else {
      throw Exception('Failed to get farm by ID');
    }
  }
}
