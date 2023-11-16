import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class MaterialService {
  Future<List<Map<String, dynamic>>> getMaterial() async {
    final String getMaterialsUrl = '$baseUrl/Material';

    final http.Response response = await http.get(
      Uri.parse(getMaterialsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> materials =
          List<Map<String, dynamic>>.from(data['data']);
      return materials;
    } else {
      throw Exception('Failed to get materials');
    }
  }

  Future<List<Map<String, dynamic>>> getMaterialActiveByFamrId(
      int farmId) async {
    final String getMaterialsUrl = '$baseUrl/Material/Active/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getMaterialsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      throw Exception('Failed to get materials');
    }
  }

  Future<List<Map<String, dynamic>>> getMaterialAllByFamrId(int farmId) async {
    final String getMaterialsUrl = '$baseUrl/Material/Farm($farmId)';

    final http.Response response = await http.get(
      Uri.parse(getMaterialsUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ems =
          List<Map<String, dynamic>>.from(data['data']);
      return ems;
    } else {
      throw Exception('Failed to get materials');
    }
  }

  Future<bool> createMaterial(int farmId, String name, File? image) async {
    final String url = '$baseUrl/Material';
    Dio dio = Dio();

    // Tạo FormData để chứa dữ liệu multipart
    FormData formData = FormData();

    // Thêm description vào FormData
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('farmId', farmId.toString()));

    if (image != null)
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(image.path),
      ));

    try {
      // Gửi request POST với FormData
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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

  Future<bool> changeStatusMaterial(int materialId) async {
    final String url = '$baseUrl/Material/Delete/$materialId';

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

  Future<bool> updateMaterial(
      int materialId, int farmId, String name, File? image) async {
    final String url = '$baseUrl/Material/$materialId';
    Dio dio = Dio();

    // Tạo FormData để chứa dữ liệu multipart
    FormData formData = FormData();

    // Thêm description vào FormData
    formData.fields.add(MapEntry('name', name));
    formData.fields.add(MapEntry('farmId', farmId.toString()));

    if (image != null)
      formData.files.add(MapEntry(
        'imageFile',
        await MultipartFile.fromFile(image.path),
      ));

    try {
      // Gửi request POST với FormData
      Response response = await dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      print(response);
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
