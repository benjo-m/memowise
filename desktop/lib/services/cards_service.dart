import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/card_response.dart';
import 'package:desktop/dto/card_stats_response.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:http/http.dart' as http;

class CardService {
  Future<PaginatedResponse<CardResponse>> getAllCards({
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

  Future<PaginatedResponse<CardStatsResponse>> getAllCardsStats({
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

  // Future<FeedbackResponse> getFeedbackById(int id) async {
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/feedback/$id'), headers: {
  //     'Content-Type': 'application/json',
  //   });

  //   final feedbackResponse =
  //       FeedbackResponse.fromJson(jsonDecode(response.body));

  //   return feedbackResponse;
  // }

  // Future<void> updateFeedbackStatus(
  //     int id, FeedbackStatusUpdateRequest req) async {
  //   await http.put(
  //     Uri.parse('$baseUrl/feedback/$id/status'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(req),
  //   );
  // }

  // Future<FeedbackResponse> removeFeedback(int id) async {
  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/feedback/$id'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   final feedbackResponse =
  //       FeedbackResponse.fromJson(jsonDecode(response.body));

  //   return feedbackResponse;
  // }
}
