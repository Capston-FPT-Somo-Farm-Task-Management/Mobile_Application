import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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
        'Authorization': 'Bearer $accessToken',
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
        'Authorization': 'Bearer $accessToken',
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
        'Authorization': 'Bearer $accessToken',
      },
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

  Future<List<Map<String, dynamic>>> getTasksByManagerIdDateStatus(
      int index,
      int pagesize,
      int userId,
      DateTime? date,
      int status,
      String search,
      int? checkParent) async {
    var dateTime = "";
    if (date != null) {
      dateTime = DateFormat('yyyy-MM-dd').format(date);
    }

    final String getTasksUrl =
        '$baseUrl/FarmTask/PageIndex($index)/PageSize($pagesize)/Manager($userId)/Status($status)/Date?date=$dateTime&checkTaskParent=$checkParent&taskName=$search';
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
          List<Map<String, dynamic>>.from(data['data']['farmTasks']);
      return tasks;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Map<String, dynamic>>> getTasksBySupervisorIdDateStatus(
      int index,
      int pagesize,
      int userId,
      DateTime? date,
      int status,
      String? search,
      int? checkParent) async {
    var dateTime = "";
    if (date != null) {
      dateTime = DateFormat('yyyy-MM-dd').format(date);
    }

    final String getTasksUrl =
        '$baseUrl/FarmTask/PageIndex($index)/PageSize($pagesize)/Supervisor($userId)/Status($status)/Date?date=$dateTime&checkTaskParent=$checkParent&taskName=$search';

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
          List<Map<String, dynamic>>.from(data['data']['farmTasks']);
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

  Future<bool> createTaskDraft(Map<String, dynamic> taskData) async {
    final String apiUrl = "$baseUrl/FarmTask/CreateTaskDraft";
    var body = jsonEncode(taskData);
    print(body);
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

  Future<bool> createTaskTodo(Map<String, dynamic> taskData) async {
    final String apiUrl = "$baseUrl/FarmTask/CreateTaskToDo";
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

  Future<bool> changeTaskStatus(int taskId, int newStatus) async {
    try {
      final String apiUrl =
          "$baseUrl/FarmTask/ChangeStatus/$taskId?status=$newStatus";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
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

  Future<bool> rejectTaskStatus(int taskId, String description) async {
    try {
      final String apiUrl = "$baseUrl/FarmTask/($taskId)/Disagree";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(description),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return Future.error(data['message']);
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<bool> cancelRejectTaskStatus(int taskId) async {
    try {
      final String apiUrl = "$baseUrl/FarmTask/Task($taskId)/Refuse";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return Future.error(data['message']);
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<bool> endTaskAndTimeKeeping(
      int taskId, int status, List<Map<String, dynamic>> data) async {
    try {
      final String apiUrl =
          "$baseUrl/FarmSubTask/Task($taskId)/UpdateEffortTimeAndStatusTask";
      var body = jsonEncode(data);
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
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
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getTasksByDateEmployeeId(int employeeId,
      DateTime? start, DateTime? end, int index, int pageSize) async {
    var startDate = "";
    if (start != null) {
      startDate = DateFormat('yyyy-MM-dd').format(start);
    }
    var endDate = "";
    if (end != null) {
      endDate = DateFormat('yyyy-MM-dd').format(end);
    }
    final String apiUrl =
        "$baseUrl/FarmTask/PageIndex($index)/PageSize($pageSize)/Done/Employee($employeeId)?startDay=$startDate&endDay=$endDate";
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> tasks =
          List<Map<String, dynamic>>.from(data['data']['taskByEmployeeDates']);
      return tasks;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> updateTask(Map<String, dynamic> taskData, int taskId) async {
    final String apiUrl = "$baseUrl/FarmTask/(${taskId})/UpdateTask";
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

  Future<bool> updateTaskandChangeTodo(
      Map<String, dynamic> taskData, int taskId) async {
    final String apiUrl =
        "$baseUrl/FarmTask/(${taskId})/UpdateTaskDraftAndToPrePare";
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

  Future<bool> updateStatusFromTodoToDraft(int taskId) async {
    final String apiUrl =
        "$baseUrl/FarmTask/(${taskId})/updateStatusFromTodoToDraft";
    final response = await http.put(
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

  Future<bool> changeStatusToDoing(int taskId) async {
    final String apiUrl = "$baseUrl/FarmTask/(${taskId})/ChangeStatusToDoing";
    final response = await http.put(
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

  Future<bool> changeStatusToDone(int taskId) async {
    final String apiUrl = "$baseUrl/FarmTask/(${taskId})/ChangeStatusToDone";
    final response = await http.put(
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

  Future<bool> addEmployeeToTaskAsign(
      Map<String, dynamic> taskData, int taskId) async {
    final String apiUrl =
        "$baseUrl/FarmTask/(${taskId})/AddEmployeeToTaskAsign";
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

  Future<bool> updateTaskDisagreeAndChangeToToDo(
      Map<String, dynamic> taskData, int taskId) async {
    final String apiUrl =
        "$baseUrl/FarmTask/(${taskId})/UpdateTaskDisagreeAndChangeToToDo";
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

  Future<bool> hideTask(int taskId) async {
    final String apiUrl = "$baseUrl/FarmTask/DeleteTask/$taskId";

    final http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
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

  Future<bool> deleteTask(int taskId) async {
    try {
      final String apiUrl = "$baseUrl/FarmTask/($taskId)";

      final http.Response response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print(response.body);
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

  Future<List<Map<String, dynamic>>> getTotalTaskOfWeekByMember(
    int memberId,
  ) async {
    final String getTasksUrl =
        '$baseUrl/FarmTask/GetTotalTaskOfWeekByMember($memberId)';

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

  Future<bool> changeStatusToPendingAndCancel(int taskId, int status,
      int? managerId, String description, List<File> images) async {
    final String url;
    if (managerId != null)
      url =
          '$baseUrl/FarmTask/($taskId)/ChangeStatusToPendingAndCancel?status=$status&managerId=$managerId';
    else
      url =
          '$baseUrl/FarmTask/($taskId)/ChangeStatusToPendingAndCancel?status=$status';
    Dio dio = Dio();
    print(url);
    // Tạo FormData để chứa dữ liệu multipart
    FormData formData = FormData();

    // Thêm description vào FormData
    formData.fields.add(MapEntry('description', description));

    // Thêm hình ảnh vào FormData
    for (int i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(images[i].path),
      ));
    }

    try {
      // Gửi request POST với FormData
      Response response = await dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // Kiểm tra status code
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

  Future<bool> changeStatusFromDoneToDoing(
      int taskId, int managerId, String description) async {
    try {
      final String apiUrl =
          "$baseUrl/FarmTask/($taskId)/ChangeStatusFromDoneToDoing?managerId=$managerId";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(description),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return Future.error(data['message']);
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<bool> changeStatusToClose(int taskId) async {
    try {
      final String apiUrl = "$baseUrl/FarmTask/($taskId)/ChangeStatusToClose";

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return Future.error(data['message']);
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }
}
