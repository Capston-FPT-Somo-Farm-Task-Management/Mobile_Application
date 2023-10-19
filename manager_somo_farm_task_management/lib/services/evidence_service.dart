import 'dart:convert';

import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class EvidenceService {
  Future<List<Map<String, dynamic>>> getEvidencebyTaskId(int taskId) async {
    final String getZonesUrl = '$baseUrl/TaskEvidence/Task($taskId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> evidence =
          List<Map<String, dynamic>>.from(data['data']);
      return evidence;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> deleteEvidence(int evidenceId) async {
    final String url = '$baseUrl/TaskEvidence/${evidenceId}';
    final response = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
