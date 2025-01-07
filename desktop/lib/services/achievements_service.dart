import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/achievement_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class AchievementService extends BaseCRUDService<AchievementResponse> {
  Future<PaginatedResponse<AchievementResponse>> getAll(
      {int page = 1, String sortBy = "id", bool sortDescending = false}) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/achievements?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending'),
        headers: {
          'Content-Type': 'application/json',
        });

    final achievements = PaginatedResponse<AchievementResponse>.fromJson(
      jsonDecode(response.body),
      (json) => AchievementResponse.fromJson(json),
    );

    return achievements;
  }

  AchievementService(super.baseUrl, super.client);

  // Future<AchievementResponse> getById(int id) async {
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/achievements/$id'), headers: {
  //     'Content-Type': 'application/json',
  //   });

  //   final achievementResponse =
  //       AchievementResponse.fromJson(jsonDecode(response.body));

  //   return achievementResponse;
  // }
}
