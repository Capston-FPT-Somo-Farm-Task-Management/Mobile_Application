import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class TaskService {
  Future<List<Map<String, dynamic>>> getTasksByUserId(int userId) async {
    final String getTasksUrl = '$baseUrl/FarmTask/Member/$userId';

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
      throw Exception('Failed to get tasks by user ID');
    }
  }

  Future<Map<String, dynamic>> getTasksByTaskId(int taskId) async {
    final String getTasksUrl = '$baseUrl/FarmTask/$taskId';

    final http.Response response = await http.get(
      Uri.parse(getTasksUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> task = json.decode(response.body);
      return task;
    } else {
      throw Exception('Failed to get tasks by user ID');
    }
  }
}
