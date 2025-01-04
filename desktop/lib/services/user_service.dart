import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/dto/user_stats_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<PaginatedResponse<UserResponse>> getAllUsers({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    String? username,
    String? email,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/users?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&username=${username ?? ""}&email=${email ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
        });

    final decks = PaginatedResponse<UserResponse>.fromJson(
      jsonDecode(response.body),
      (json) => UserResponse.fromJson(json),
    );

    return decks;
  }

  Future<PaginatedResponse<UserStatsResponse>> getAllUserStats({
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
        });

    final userStats = PaginatedResponse<UserStatsResponse>.fromJson(
      jsonDecode(response.body),
      (json) => UserStatsResponse.fromJson(json),
    );

    return userStats;
  }
}
