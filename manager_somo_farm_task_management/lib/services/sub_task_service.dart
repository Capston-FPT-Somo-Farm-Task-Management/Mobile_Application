import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class SubTaskService {
  Future<List<Map<String, dynamic>>> getSubTaskByTaskId(int taskId) async {
    final String getTasksUrl = '$baseUrl/FarmSubTask/Task($taskId)';

    final http.Response response = await http.get(
      Uri.parse(getTasksUrl),
      headers: {
        'Content-Type': 'application/json',
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
    final String apiUrl = "$baseUrl/FarmSubTask/Task";
    var body = jsonEncode(taskData);
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

  Future<bool> deleteSubTask(int taskId, int employeeId) async {
    final String apiUrl =
        "$baseUrl/FarmSubTask/Delete/Task(${taskId})/Employee(${employeeId})";
    final response = await http.put(
      Uri.parse(apiUrl),
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
