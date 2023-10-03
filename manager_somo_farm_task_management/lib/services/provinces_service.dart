import 'dart:convert';

import 'package:http/http.dart' as http;

class ProvincesService {
  String baseUrl = "https://provinces.open-api.vn/api";
  Future<List<Map<String, dynamic>>> getProvinces() async {
    final String getProvincesUrl = '$baseUrl/p/';

    final http.Response response = await http.get(
      Uri.parse(getProvincesUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          json.decode(utf8.decode(response.bodyBytes)));
      return data;
    } else {
      throw Exception('Failed to get provinces');
    }
  }

  Future<List<Map<String, dynamic>>> getDistrictsByProvinceCode(
      int code) async {
    final String getDistrictsUrl = '$baseUrl/p/$code?depth=2';

    final http.Response response = await http.get(
      Uri.parse(getDistrictsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      final List<Map<String, dynamic>> districts =
          List<Map<String, dynamic>>.from(responseData['districts']);
      return districts;
    } else {
      throw Exception('Failed to get Districts');
    }
  }

  Future<List<Map<String, dynamic>>> getWarsByDistrictCode(int code) async {
    final String getWarsUrl = '$baseUrl/d/$code?depth=2';

    final http.Response response = await http.get(
      Uri.parse(getWarsUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      final List<Map<String, dynamic>> wards =
          List<Map<String, dynamic>>.from(responseData['wards']);
      return wards;
    } else {
      throw Exception('Failed to get Wars');
    }
  }
}
