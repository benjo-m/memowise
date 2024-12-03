import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/dtos/generate_cards_response.dart';
import 'package:mobile/models/card.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';

import '../models/deck.dart';

class DeckService {
  // final String baseUrl = 'http://10.0.2.2:5151/decks';
  final String baseUrl = 'http://localhost:5151/decks';

  Future<List<DeckSummary>> getDecks() async {
    String? uid = FirebaseAuthProvider().currentUser?.uid;
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/user/$uid'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => DeckSummary.fromJson(json)).toList();
  }

  Future<Deck> createDeck(DeckCreateRequest deckCreateRequest) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.post(Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(deckCreateRequest));

    Deck deck = Deck.fromJson(jsonDecode(response.body));

    return deck;
  }

  Future<void> deleteDeck(int deckId) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    await http.delete(
      Uri.parse('$baseUrl/$deckId'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
  }

  Future<Deck> getDeckById(int deckId) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$deckId'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    Deck deck = Deck.fromJson(jsonDecode(response.body));

    return deck;
  }

  Future<void> editCard(int deckId, int cardId, CardDto cardDto) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    http.patch(
      Uri.parse("$baseUrl/$deckId/cards/$cardId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(cardDto),
    );
  }

  Future<Card> deleteCard(int deckId, int cardId) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/$deckId/cards/$cardId"),
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
      Uri.parse("$baseUrl/$deckId/cards"),
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
