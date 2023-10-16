import 'dart:convert';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class HubConnectionService {
  Future<bool> createConnection(Map<String, dynamic> data) async {
    final String url = '$baseUrl/HubConnection';
    var body = jsonEncode(data);
    final response = await http.post(
      Uri.parse(url),
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
}
