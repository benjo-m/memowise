import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class CardService extends BaseCRUDService<CardResponse> {
  CardService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/achievements',
          client,
          (json) => CardResponse.fromJson(json),
        );

  Future<PaginatedResponse<CardResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? deck,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cards?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&deck=${deck ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
        });

    final cards = PaginatedResponse<CardResponse>.fromJson(
      jsonDecode(response.body),
      (json) => CardResponse.fromJson(json),
    );

    return cards;
  }
}
