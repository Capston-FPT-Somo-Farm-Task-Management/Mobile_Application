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

  Future<bool> DeleteLiveStock(int id) async {
    final String deleteLiveStockUrl = '$baseUrl/LiveStock/Delete/${id}';

    final http.Response response = await http.put(
      Uri.parse(deleteLiveStockUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete livestock');
    }
  }

  Future<bool> CreateLiveStock(Map<String, dynamic> liveStock) async {
    final String createLiveStockUrl = '$baseUrl/LiveStock';
    var body = jsonEncode(liveStock);
    final response = await http.post(Uri.parse(createLiveStockUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
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

  Future<bool> UpdateLiveStock(Map<String, dynamic> liveStock, int id) async {
    final String updateLiveStockUrl = '$baseUrl/LiveStock/${id}';
    var body = jsonEncode(liveStock);
    final response = await http.put(Uri.parse(updateLiveStockUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      final Map<String, dynamic> data = json.decode(response.body);
      return Future.error(data['message']);
    }
  }
}
