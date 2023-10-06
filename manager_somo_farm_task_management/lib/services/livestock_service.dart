import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_somo_farm_task_management/componets/constants.dart';

class LiveStockService {
  Future<List<Map<String, dynamic>>> getLiveStockExternalIdsByFieldId(
      int fieldId) async {
    final String getTasksUrl = '$baseUrl/LiveStock/ExternalId/Field($fieldId)';

    final http.Response response = await http.get(
      Uri.parse(getTasksUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> ids =
          List<Map<String, dynamic>>.from(data['data']);
      return ids;
    } else {
      throw Exception('Failed to get LiveStock ExternalIds by user ID');
    }
  }

  Future<List<Map<String, dynamic>>> getAllLiveStock() async {
    final String getLiveStockUrl = '$baseUrl/LiveStock';

    final http.Response response = await http.get(
      Uri.parse(getLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> liveStocks =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return liveStocks;
    } else {
      throw Exception('Failed to get LiveStocks');
    }
  }

  Future<Map<String, dynamic>> getLiveStockById(int id) async {
    final String getLiveStockUrl = '$baseUrl/LiveStock/&id';

    final http.Response response = await http.get(
      Uri.parse(getLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> liveStock =
          Map<String, dynamic>.from(json.decode(response.body));
      return liveStock;
    } else {
      throw Exception('Failed to get livestock');
    }
  }

  Future<Map<String, dynamic>> deleteLiveStock(int id, String status) async {
    final String deleteLiveStockUrl = '$baseUrl/LiveStock/ChangeStatus/${id}';
    var body = jsonEncode({"status": status});
    final http.Response response = await http.put(Uri.parse(deleteLiveStockUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> liveStock =
          Map<String, dynamic>.from(json.decode(response.body));
      return liveStock;
    } else {
      throw Exception('Failed to delete livestock');
    }
  }

  Future<Map<String, dynamic>> CreateLiveStock(
      Map<String, dynamic> liveStock) async {
    final String createLiveStockUrl = '$baseUrl/LiveStock';
    var body = jsonEncode(liveStock);
    final response = await http.post(Uri.parse(createLiveStockUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> liveStock =
          Map<String, dynamic>.from(json.decode(response.body));
      return liveStock;
    } else {
      throw Exception('Failed to create liveStock');
    }
  }

  Future<List<Map<String, dynamic>>> getLiveStockByFarmId(int id) async {
    final String getLiveStockUrl = '$baseUrl/LiveStock/Farm(${id})';

    final http.Response response = await http.get(
      Uri.parse(getLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> liveStocks =
          List<Map<String, dynamic>>.from(data['data']);
      return liveStocks;
    } else {
      throw Exception('Failed to get LiveStocks');
    }
  }
}
