import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  Future<Map<String, dynamic>> Login(String username, String password) async {
    final String loginUrl = '$baseUrl/Login';

    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    final http.Response response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String aToken = responseData['accessToken'];
      final String refreshToken = responseData['refreshToken'];

      accessToken = aToken;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      final String role = decodedToken[
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      final String id = decodedToken['Id'];
      final String username = decodedToken['UserName'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = int.parse(id);
      prefs.setInt('userId', userId);
      prefs.setString('role', role);
      prefs.setString('accessToken', accessToken);
      return {
        'role': role,
        'id': userId,
        'username': username,
      };
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<String?> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      // Xử lý khi không có refresh token
      return null;
    }

    final String refreshUrl = '$baseUrl/RefreshToken';

    final Map<String, String> body = {
      'refreshToken': refreshToken,
    };

    final http.Response response = await http.post(
      Uri.parse(refreshUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String newAccessToken = responseData['accessToken'];

      // Cập nhật access token mới trong SharedPreferences
      prefs.setString('accessToken', newAccessToken);

      return newAccessToken;
    } else {
      // Xử lý khi refresh token không hợp lệ
      return null;
    }
  }
}
