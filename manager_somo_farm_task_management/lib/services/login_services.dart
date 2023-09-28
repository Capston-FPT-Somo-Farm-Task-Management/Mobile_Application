import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String baseUrl = "https://somotaskapi.azurewebsites.net/api";

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
      final String accessToken = responseData['accessToken'];
      final String refreshToken = responseData['refreshToken'];

      Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);

      final String role = decodedToken[
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      final String id = decodedToken['Id'];
      final String username = decodedToken['UserName'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userId = int.parse(id);
      prefs.setInt('userId', userId);
      prefs.setString('role', role);
      return {
        'role': role,
        'id': userId,
        'username': username,
      };
    } else {
      throw Exception('Failed to log in');
    }
  }
}
