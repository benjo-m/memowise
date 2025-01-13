import 'dart:convert';
import 'dart:io';

import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/dtos/generate_cards_response.dart';
import 'package:mobile/models/card.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:http/http.dart' as http;

class CardService {
  Future<void> editCard(int cardId, CardDto cardDto) async {
    http.put(
      Uri.parse("$baseUrl/cards/edit/$cardId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(cardDto),
    );
  }

  Future<Card> deleteCard(int cardId) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/cards/$cardId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    Card card = Card.fromJson(jsonDecode(response.body));

    return card;
  }

  Future<Card> createCard(int deckId, CardDto cardDto) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cards/$deckId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(cardDto),
    );

    Card card = Card.fromJson(jsonDecode(response.body));

    return card;
  }

  Future<GenerateCardsResponse> generateCards(
      GenerateCardsRequest generateCardsRequest) async {
    final response = await http.post(
      Uri.parse("$baseUrl/cards/generate"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(generateCardsRequest),
    );

    GenerateCardsResponse generatedCards =
        GenerateCardsResponse.fromJson(jsonDecode(response.body));

    return generatedCards;
  }

  Future<void> updateCardStats(CardStatsUpdateRequest request) async {
    http.put(
      Uri.parse("$baseUrl/cards/learning-stats"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(request),
    );
  }
}
