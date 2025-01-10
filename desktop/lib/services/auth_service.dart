import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/login_request.dart';
import 'package:desktop/dto/login_response.dart';
import 'package:http/http.dart' as http;

class CurrentUser {
  static int? userId;
  static bool? isSuperAdmin;
}

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

  logOut() {
    CurrentUser.userId = null;
    CurrentUser.isSuperAdmin = null;
  }
}
