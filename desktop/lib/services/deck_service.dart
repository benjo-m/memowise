import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class DeckService extends BaseCRUDService<DeckResponse> {
  DeckService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/decks',
          client,
          (json) => DeckResponse.fromJson(json),
        );

  Future<PaginatedResponse<DeckResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? user,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/decks?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&user=${user ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
        });

    final decks = PaginatedResponse<DeckResponse>.fromJson(
      jsonDecode(response.body),
      (json) => DeckResponse.fromJson(json),
    );

    return decks;
  }
}
