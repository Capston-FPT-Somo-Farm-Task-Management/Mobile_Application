import 'dart:convert';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<Map<String, dynamic>> getCountNewNotificationByMemberId(
      int memberId) async {
    final String getAreasUrl =
        '$baseUrl/Notification/New/Member($memberId)/Count';

    final http.Response response = await http.get(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
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
