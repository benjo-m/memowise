import 'dart:convert';
import 'dart:io';

import 'package:mobile/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/dtos/change_password_request.dart';
import 'package:mobile/dtos/delete_user_request.dart';
import 'package:mobile/dtos/stats_response.dart';
import 'package:mobile/dtos/update_user_request.dart';
import 'package:mobile/services/auth/current_user.dart';

import 'auth/auth_exceptions.dart';

class UserService {
  Future<void> updateUser(UpdateUserRequest updateUserRequest) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(updateUserRequest),
    );

    if (response.statusCode == 409) {
      final responseBody = jsonDecode(response.body);
      responseBody['errorCode'] == "USERNAME_TAKEN"
          ? throw UsernameTakenException()
          : throw EmailAlreadyInUseException();
    }
  }

  Future<void> changePassword(
      ChangePasswordRequest changePasswordRequest) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/password-change"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(changePasswordRequest),
    );

    if (response.statusCode == 401) {
      throw WrongPasswordException();
    }
  }

  Future<void> deleteUser(DeleteUserRequest deleteUserRequest) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/users"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(deleteUserRequest),
    );

    if (response.statusCode == 401) {
      throw WrongPasswordException();
    }
  }

  Future<void> deleteAllData() async {
    await http.put(
      Uri.parse("$baseUrl/userstats/delete-data/${CurrentUser.userId}"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );
  }

  Future<void> upgradeToPremium(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/premium-upgrade/$userId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    if (response.statusCode == 200) {
      CurrentUser.isPremium = true;
    }
  }

  Future<StatsResponse> getStats(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/userstats/${CurrentUser.userId}"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    return StatsResponse.fromJson(jsonDecode(response.body));
  }
}
