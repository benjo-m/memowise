import 'dart:convert';

import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/login_request.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/dtos/login_response.dart';
import 'package:mobile/dtos/register_request.dart';
import 'package:mobile/dtos/register_response.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/current_user.dart';

class AuthService {
  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginRequest),
    );

    if (response.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      return loginResponse;
    } else {
      return null;
    }
  }

  Future<RegisterResponse> register(RegisterRequest registerRequest) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(registerRequest),
    );

    if (response.statusCode == 200) {
      final registerReponse =
          RegisterResponse.fromJson(jsonDecode(response.body));
      return registerReponse;
    } else if (response.statusCode == 409) {
      final responseBody = jsonDecode(response.body);
      responseBody['errorCode'] == "USERNAME_TAKEN"
          ? throw UsernameTakenException()
          : throw EmailAlreadyInUseException();
    } else if (response.statusCode == 400) {
      throw PasswordsNotMatching();
    } else {
      throw Exception("Server error");
    }
  }

  void logout() {
    CurrentUser.userId = null;
    CurrentUser.username = null;
    CurrentUser.email = null;
    CurrentUser.password = null;
    CurrentUser.authHeader = null;
    CurrentUser.isPremium = null;
    CurrentUser.isAdmin = null;
  }
}
