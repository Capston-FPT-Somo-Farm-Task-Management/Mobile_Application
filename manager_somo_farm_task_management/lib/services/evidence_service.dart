import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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

  Future<Map<String, dynamic>> getEvidencebyId(int evidenceId) async {
    final String getZonesUrl = '$baseUrl/TaskEvidence/$evidenceId';

    final http.Response response = await http.get(
      Uri.parse(getZonesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> evidence =
          Map<String, dynamic>.from(data['data']);
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
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> createEvidence(
      int taskId, String description, List<File> images) async {
    final String url = '$baseUrl/TaskEvidence/AddTaskEvidenceeWithImage';
    Dio dio = Dio();

    // Tạo FormData để chứa dữ liệu multipart
    FormData formData = FormData();

    // Thêm description vào FormData
    formData.fields.add(MapEntry('description', description));
    formData.fields.add(MapEntry('taskId', taskId.toString()));

    // Thêm hình ảnh vào FormData
    for (int i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(images[i].path),
      ));
    }

    try {
      // Gửi request POST với FormData
      Response response = await dio.post(
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

  Future<bool> updateEvidenceById(int evidenceId, int taskId,
      String description, List<dynamic> urlImages, List<File> images) async {
    final String url = '$baseUrl/TaskEvidence/${evidenceId}';
    Dio dio = Dio();

    // Tạo FormData để chứa dữ liệu multipart
    FormData formData = FormData();

    // Thêm description vào FormData
    formData.fields
        .add(MapEntry('evidenceCreateUpdateModel.description', description));
    formData.fields
        .add(MapEntry('evidenceCreateUpdateModel.taskId', taskId.toString()));

    // Thêm hình ảnh vào FormData
    for (int i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'evidenceCreateUpdateModel.imageFile',
        await MultipartFile.fromFile(images[i].path),
      ));
    }
    // Thêm đường dẫn hình ảnh vào FormData
    for (int i = 0; i < urlImages.length; i++) {
      formData.fields.add(MapEntry(
        'oldUrlImage',
        urlImages[i],
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
}
