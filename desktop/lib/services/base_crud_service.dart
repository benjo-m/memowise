import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:desktop/exceptions/exceptions.dart';
import 'package:desktop/services/auth_service.dart';
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
      final response = await _client.get(Uri.parse('$baseUrl/$id'), headers: {
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      });
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
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return fromJson(json);
      } else if (response.statusCode == 409) {
        final responseBody = jsonDecode(response.body);
        switch (responseBody['errorCode']) {
          case "USERNAME_TAKEN":
            throw UsernameTakenException();
          case "EMAIL_TAKEN":
            throw EmailAlreadyInUseException();
          case "ACHIEVEMENT_NAME_TAKEN":
            throw AchievementNameTakenException();
          default:
            throw DuplicateException();
        }
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        switch (responseBody['errorCode']) {
          case "USER_DOES_NOT_EXIST":
            throw InvalidUserIdException();
          case "DECK_DOES_NOT_EXIST":
            throw InvalidDeckIdException();
          case "CARD_DOES_NOT_EXIST":
            throw InvalidCardIdException();
          default:
            throw Exception("Status kode 400");
        }
      } else {
        log('Failed to create entity: ${response.statusCode}');
        return null;
      }
    } on UsernameTakenException {
      rethrow;
    } on EmailAlreadyInUseException {
      rethrow;
    } on AchievementNameTakenException {
      rethrow;
    } on InvalidUserIdException {
      rethrow;
    } on InvalidDeckIdException {
      rethrow;
    } on InvalidCardIdException {
      rethrow;
    } on DuplicateException {
      rethrow;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  Future<TEntity?> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return fromJson(json);
      } else if (response.statusCode == 409) {
        final responseBody = jsonDecode(response.body);
        switch (responseBody['errorCode']) {
          case "USERNAME_TAKEN":
            throw UsernameTakenException();
          case "EMAIL_TAKEN":
            throw EmailAlreadyInUseException();
          case "ACHIEVEMENT_NAME_TAKEN":
            throw AchievementNameTakenException();
          default:
            throw DuplicateException();
        }
      } else if (response.statusCode == 400) {
        final responseBody = jsonDecode(response.body);
        switch (responseBody['errorCode']) {
          case "USER_DOES_NOT_EXIST":
            throw InvalidUserIdException();
          case "DECK_DOES_NOT_EXIST":
            throw InvalidDeckIdException();
          case "CARD_DOES_NOT_EXIST":
            throw InvalidCardIdException();
          default:
            throw Exception("Status kode 400");
        }
      } else {
        log('Failed to update entity: ${response.statusCode}');
        return null;
      }
    } on UsernameTakenException {
      rethrow;
    } on EmailAlreadyInUseException {
      rethrow;
    } on AchievementNameTakenException {
      rethrow;
    } on InvalidUserIdException {
      rethrow;
    } on InvalidDeckIdException {
      rethrow;
    } on InvalidCardIdException {
      rethrow;
    } on DuplicateException {
      rethrow;
    } catch (e) {
      log('Error updating entity: $e');
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      final response =
          await _client.delete(Uri.parse('$baseUrl/$id'), headers: {
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      });
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
