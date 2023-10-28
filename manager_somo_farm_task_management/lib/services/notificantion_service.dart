import 'dart:convert';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:http/http.dart' as http;

class NotiService {
  Future<int> getCountNewNotificationByMemberId(int memberId) async {
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
      final int count = data['data'] as int;
      return count;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getAllNotificationByMemberId(
      int index, int pageSize, int memberId) async {
    final String getAreasUrl =
        '$baseUrl/Notification/PageIndex($index)/PageSize($pageSize)/Member($memberId)';

    final http.Response response = await http.get(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> n =
          List<Map<String, dynamic>>.from(data['data']['notifications']);
      return n;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getIsReadNotificationByMemberId(
      int memberId) async {
    final String getAreasUrl = '$baseUrl/Notification/Read/Member$memberId';

    final http.Response response = await http.get(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> n =
          List<Map<String, dynamic>>.from(data['data']);
      return n;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getNotSeenNotificationByMemberId(
      int index, int sizePage, int memberId) async {
    final String getAreasUrl =
        '$baseUrl/Notification/PageIndex($index)/PageSize($sizePage)/NotSeen/Member$memberId';

    final http.Response response = await http.get(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> n =
          List<Map<String, dynamic>>.from(data['data']['notifications']);
      return n;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> makeAllNotiIsOld(int memberId) async {
    final String getAreasUrl =
        '$baseUrl/Notification/IsNew/MemberId($memberId)';

    final http.Response response = await http.put(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> isReadNoti(int notiId) async {
    final String getAreasUrl = '$baseUrl/Notification/IsRead($notiId)';

    final http.Response response = await http.put(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }

  Future<bool> makeAllNotiIsRead(int memberId) async {
    final String getAreasUrl =
        '$baseUrl/Notification/All/IsRead/Member($memberId)';

    final http.Response response = await http.put(
      Uri.parse(getAreasUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
