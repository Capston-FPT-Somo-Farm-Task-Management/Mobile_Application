import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class EmployeeService {
  Future<List<Map<String, dynamic>>> getEmployeesbyFarmIdAndTaskTypeId(
      int farmId, int taskTypeId) async {
    final String getZonesUrl =
        '$baseUrl/Employee/Active/TaskType($taskTypeId)/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> zones =
          List<Map<String, dynamic>>.from(data['data']);
      return zones;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesbyFarmId(int farmId) async {
    final String getEmsUrl = '$baseUrl/Employee/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getEmsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesbyTaskId(int taskId) async {
    final String url = '$baseUrl/Employee/Task($taskId)';

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getEmployeesNoActivitiesbyTaskId(
      int taskId) async {
    final String url = '$baseUrl/Activities/EmployeeNoActivities($taskId)';

    final http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createEmployee(
      Map<String, dynamic> employeeData, File? image) async {
    final String apiUrl = "$baseUrl/Employee";

    Dio dio = Dio();
    FormData formData = FormData();

    formData.fields.add(MapEntry('name', employeeData['employee']['name']));
    formData.fields.add(MapEntry('code', employeeData['employee']['code']));
    formData.fields
        .add(MapEntry('phoneNumber', employeeData['employee']['phoneNumber']));
    formData.fields
        .add(MapEntry('address', employeeData['employee']['address']));
    formData.fields
        .add(MapEntry('gender', employeeData['employee']['gender'].toString()));
    formData.fields.add(MapEntry(
        'dateOfBirth', employeeData['employee']['dateOfBirth'].toString()));
    for (int i = 0; i < employeeData['taskTypeId'].length; i++) {
      formData.fields.add(
          MapEntry('taskTypeIds', employeeData['taskTypeId'][i].toString()));
    }
    formData.fields
        .add(MapEntry('farmId', employeeData['employee']['farmId'].toString()));

    if (image != null)
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(image.path),
      ));

    Response response = await dio.post(
      apiUrl,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeStatusEmployee(int employeeId) async {
    final String url = '$baseUrl/Employee/ChangeStatus/$employeeId';

    final http.Response response = await http.put(
      Uri.parse(url),
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

  Future<bool> updateEmployee(
      int employeeId, Map<String, dynamic> employeeData, File? image) async {
    final String apiUrl = "$baseUrl/Employee/$employeeId";
    Dio dio = Dio();
    FormData formData = FormData();

    formData.fields.add(MapEntry('name', employeeData['employee']['name']));
    formData.fields.add(MapEntry('code', employeeData['employee']['code']));
    formData.fields
        .add(MapEntry('phoneNumber', employeeData['employee']['phoneNumber']));
    formData.fields
        .add(MapEntry('address', employeeData['employee']['address']));
    formData.fields
        .add(MapEntry('gender', employeeData['employee']['gender'].toString()));
    formData.fields.add(MapEntry(
        'dateOfBirth', employeeData['employee']['dateOfBirth'].toString()));
    for (int i = 0; i < employeeData['taskTypeIds'].length; i++) {
      formData.fields.add(
          MapEntry('taskTypeIds', employeeData['taskTypeIds'][i].toString()));
    }
    formData.fields
        .add(MapEntry('farmId', employeeData['employee']['farmId'].toString()));

    if (image != null)
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(image.path),
      ));

    Response response = await dio.put(
      apiUrl,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
