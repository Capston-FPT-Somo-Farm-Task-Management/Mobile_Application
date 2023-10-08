import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class TaskService {
  Future<List<Map<String, dynamic>>> getTaskActiveByUserId(int userId) async {
    final String getTasksUrl = '$baseUrl/FarmTask/TaskActive/Member/$userId';

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

  Future<List<Map<String, dynamic>>> getTasksByUserIdAndDate(
      int userId, DateTime date) async {
    var dateTime = DateFormat('yyyy-MM-dd').format(date);
    final String getTasksUrl =
        '$baseUrl/FarmTask/Member($userId)/TaskDate/$dateTime';

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

  Future<List<Map<String, dynamic>>> getTasksByUserIdDateStatus(
      int userId, DateTime date, int status) async {
    var dateTime = DateFormat('yyyy-MM-dd').format(date);
    final String getTasksUrl =
        '$baseUrl/FarmTask/Member($userId)/Status($status)/Date?date=$dateTime';

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
      throw Exception(response.body);
    }
  }

  Future<bool> createTask(Map<String, dynamic> taskData, int managerId) async {
    final String apiUrl = "$baseUrl/FarmTask?memberId=${managerId}";
    var body = jsonEncode(taskData);
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<bool> changeTaskStatus(int taskId, int newStatus) async {
    try {
      final String apiUrl =
          "$baseUrl/FarmTask/ChangeStatus/$taskId?status=$newStatus";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }
}
