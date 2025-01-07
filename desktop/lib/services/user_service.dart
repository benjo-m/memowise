import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/user_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class UserService extends BaseCRUDService<UserResponse> {
  UserService(super.baseUrl, super.client);

  Future<PaginatedResponse<UserResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    String? accountType,
    String? role,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/users?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&accountType=${accountType ?? ""}&role=${role ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
        });

    final decks = PaginatedResponse<UserResponse>.fromJson(
      jsonDecode(response.body),
      (json) => UserResponse.fromJson(json),
    );

    return decks;
  }
}
