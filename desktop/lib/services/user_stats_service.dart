import 'dart:convert';
import 'dart:io';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class UserStatsService extends BaseCRUDService<UserStatsResponse> {
  UserStatsService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/userstats',
          client,
          (json) => UserStatsResponse.fromJson(json),
        );
  Future<PaginatedResponse<UserStatsResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? user,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/userstats?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&user=${user ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final userStats = PaginatedResponse<UserStatsResponse>.fromJson(
      jsonDecode(response.body),
      (json) => UserStatsResponse.fromJson(json),
    );

    return userStats;
  }
}
