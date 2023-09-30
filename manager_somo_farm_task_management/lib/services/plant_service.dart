import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/manager/plant/add_plant_page.dart';

class PlantService {
  Future<List<Map<String, dynamic>>> getAllPlant() async {
    final String getPlantUrl = '$baseUrl/Plant';

    final http.Response response = await http.get(
      Uri.parse(getPlantUrl),
      headers: {
        'Content-Type': 'application/json',
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

  Future<List<Map<String, dynamic>>> CreatePlant() async {
    final String getPlantUrl = '$baseUrl/Plant';

    final http.Response response = await http.get(
      Uri.parse(getPlantUrl),
      headers: {
        'Content-Type': 'application/json',
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
}
