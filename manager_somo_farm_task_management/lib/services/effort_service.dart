import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class EffortService {
  Future<Map<String, dynamic>> getEffortByTaskId(int taskId) async {
    final String apiUrl = "$baseUrl/FarmSubTask/Task(${taskId})/Effort";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> task = Map<String, dynamic>.from(data['data']);
      return task;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createEffort(int taskId, List<Map<String, dynamic>> data) async {
    final String apiUrl = "$baseUrl/FarmSubTask/Task(${taskId})";
    var body = jsonEncode(data);
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createEffortBySubtask(
      int subTaskId, Map<String, dynamic> data) async {
    final String apiUrl = "$baseUrl/FarmSubTask/(${subTaskId})/Effort";
    var body = jsonEncode(data);
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<Map<String, dynamic>> getTotalEffortByEmployeeId(
      int employeeId, DateTime? startDate, DateTime? endDate) async {
    var dateTimeStart = "";
    if (startDate != null) {
      dateTimeStart = DateFormat('yyyy-MM-dd').format(startDate);
    }
    var dateTimeEnd = "";
    if (endDate != null) {
      dateTimeEnd = DateFormat('yyyy-MM-dd').format(endDate);
    }
    final String apiUrl =
        "$baseUrl/FarmSubTask/Employee(${employeeId})/TotalEffort?startDay=$dateTimeStart&endDay=$dateTimeEnd";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> e = Map<String, dynamic>.from(data['data']);
      return e;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
