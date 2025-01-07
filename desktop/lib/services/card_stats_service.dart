import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class CardStatsService extends BaseCRUDService<CardStatsResponse> {
  CardStatsService(super.baseUrl, super.client);

  Future<PaginatedResponse<CardStatsResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? card,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/cardstats?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&card=${card ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
        });

    final cards = PaginatedResponse<CardStatsResponse>.fromJson(
      jsonDecode(response.body),
      (json) => CardStatsResponse.fromJson(json),
    );

    return cards;
  }
}
