import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/deck_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:http/http.dart' as http;

class DeckService {
  Future<PaginatedResponse<DeckResponse>> getAllDecks({
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
