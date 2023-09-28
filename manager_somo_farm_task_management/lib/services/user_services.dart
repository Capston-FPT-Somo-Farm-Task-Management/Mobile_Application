import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = "https://somotaskapi.azurewebsites.net/api";

  Future<Map<String, dynamic>> getUserById(int userId) async {
    final String getUserUrl = '$baseUrl/Member/$userId';

    final http.Response response = await http.get(
      Uri.parse(getUserUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Failed to get user by ID');
    }
  }
}
