import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class SubTaskService {
  Future<List<Map<String, dynamic>>> getSubTaskByTaskId(
      int taskId, int? employeeId) async {
    final String getTasksUrl;
    if (employeeId == null)
      getTasksUrl = '$baseUrl/Activities/Task($taskId)';
    else
      getTasksUrl = '$baseUrl/Activities/Task($taskId)?employeeId=$employeeId';

    final http.Response response = await http.get(
      Uri.parse(getTasksUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> tasks =
          List<Map<String, dynamic>>.from(data['data']);
      return tasks;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createSubTask(Map<String, dynamic> taskData) async {
    final String apiUrl = "$baseUrl/Activities";
    var body = jsonEncode(taskData);
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

  Future<bool> deleteSubTask(int subTaskId) async {
    final String apiUrl = "$baseUrl/Activities/Delete(${subTaskId})";
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> updateSubTask(
      int subTaskId, Map<String, dynamic> taskData) async {
    final String apiUrl = "$baseUrl/Activities/(${subTaskId})";
    var body = jsonEncode(taskData);
    final response = await http.put(
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
}
