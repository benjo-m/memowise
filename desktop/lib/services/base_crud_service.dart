import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class BaseCRUDService<TEntity> {
  final String baseUrl;
  final http.Client _client;
  final TEntity Function(Map<String, dynamic>) fromJson;

  BaseCRUDService(
    this.baseUrl,
    http.Client client,
    this.fromJson,
  ) : _client = client;

  Future<TEntity?> getById(int id) async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as TEntity;
      } else {
        log('Failed to fetch entity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching entity: $e');
      return null;
    }
  }

  Future<TEntity?> create(Map<String, dynamic> data) async {
    try {
      final response = await _client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as TEntity;
      } else {
        log('Failed to create entity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error creating entity: $e');
      return null;
    }
  }

  Future<TEntity?> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return fromJson(json);
      } else {
        log('Failed to update entity: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error updating entity: $e');
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      final response = await _client.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        log('Failed to delete entity: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error deleting entity: $e');
      return false;
    }
  }
}
