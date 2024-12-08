import 'dart:convert';
import 'dart:io';

import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/dtos/generate_cards_response.dart';
import 'package:mobile/models/card.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:http/http.dart' as http;

class CardService {
  // final String baseUrl = 'http://10.0.2.2:5151/api/cards';
  final String baseUrl = 'http://localhost:5151/api/cards';

  Future<void> editCard(int deckId, int cardId, CardDto cardDto) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    http.patch(
      Uri.parse("$baseUrl/$cardId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(cardDto),
    );
  }

  Future<Card> deleteCard(int cardId) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/$cardId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    Card card = Card.fromJson(jsonDecode(response.body));

    return card;
  }

  Future<Card> createCard(int deckId, CardDto cardDto) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.post(
      Uri.parse("$baseUrl/$deckId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(cardDto),
    );

    Card card = Card.fromJson(jsonDecode(response.body));

    return card;
  }

  Future<GenerateCardsResponse> generateCards(
      GenerateCardsRequest generateCardsRequest) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.post(
      Uri.parse("$baseUrl/generate"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(generateCardsRequest),
    );

    GenerateCardsResponse generatedCards =
        GenerateCardsResponse.fromJson(jsonDecode(response.body));

    return generatedCards;
  }
}
