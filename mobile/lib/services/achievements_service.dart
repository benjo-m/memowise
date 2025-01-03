import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/unlocked_achievement_response.dart';
import 'package:mobile/models/achievement.dart';
import 'package:mobile/services/auth/current_user.dart';

class AchievementsService {
  Future<List<Achievement>> getAllAchievements() async {
    final response = await http.get(
      Uri.parse(
          "$baseUrl/achievements?page=1&pageSize=10&sortBy=id&sortDescending=false"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    final List<dynamic> jsonList = jsonResponse['data'];

    return jsonList.map((json) => Achievement.fromJson(json)).toList();
  }

  Future<UnlockedAchievementsResponse> getUnlockedAchievements(
      int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/achievements/user/$userId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    return UnlockedAchievementsResponse.fromJson(jsonDecode(response.body));
  }
}
