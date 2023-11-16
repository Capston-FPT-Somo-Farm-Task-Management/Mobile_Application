import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class UserService {
  Future<Map<String, dynamic>> getUserById(int userId) async {
    final String getUserUrl = '$baseUrl/Member/$userId';

    final http.Response response = await http.get(
      Uri.parse(getUserUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Failed to get user by ID');
    }
  }

  Future<bool> updateUser(
      int userId, Map<String, dynamic> userData, File? image) async {
    final String apiUrl = "$baseUrl/Member/$userId";
    Dio dio = Dio();
    FormData formData = FormData();

    formData.fields.add(MapEntry('name', userData['member']['name']));
    formData.fields.add(MapEntry('code', userData['member']['code']));
    formData.fields
        .add(MapEntry('phoneNumber', userData['member']['phoneNumber']));
    formData.fields.add(MapEntry('address', userData['member']['address']));
    formData.fields
        .add(MapEntry('email', userData['member']['email'].toString()));
    formData.fields
        .add(MapEntry('birthday', userData['member']['birthday'].toString()));

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
          'Content-Type': 'application/json',
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
