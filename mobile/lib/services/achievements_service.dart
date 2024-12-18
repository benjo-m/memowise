import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/config/constants.dart';
import 'package:mobile/models/achievement.dart';
import 'package:mobile/services/auth/current_user.dart';

class AchievementsService {
  Future<List<Achievement>> getAllAchievements() async {
    final response = await http.get(
      Uri.parse("$baseUrl/achievements"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => Achievement.fromJson(json)).toList();
  }

  Future<List<Achievement>> getUnlockedAchievements(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/achievements/user/$userId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => Achievement.fromJson(json)).toList();
  }
}
