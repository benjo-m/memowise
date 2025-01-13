import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/dtos/deck_update_request.dart';
import 'package:mobile/services/auth/current_user.dart';

import '../models/deck.dart';

class DeckService {
  Future<List<DeckSummary>> getDecks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/decks/user/${CurrentUser.userId}'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => DeckSummary.fromJson(json)).toList();
  }

  Future<Deck> getDeckById(int deckId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/decks/$deckId/cards'),
      headers: {
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    Deck deck = Deck.fromJson(jsonDecode(response.body));
    return deck;
  }

  Future<Deck> createDeck(DeckCreateRequest deckCreateRequest) async {
    final response = await http.post(Uri.parse("$baseUrl/decks/with-cards"),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        },
        body: jsonEncode(deckCreateRequest));

    Deck deck = Deck.fromJson(jsonDecode(response.body));

    return deck;
  }

  Future<void> deleteDeck(int deckId) async {
    await http.delete(
      Uri.parse('$baseUrl/decks/$deckId'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );
  }

  Future<void> updateDeck(
      int deckId, DeckUpdateRequest deckUpdateRequest) async {
    await http.put(Uri.parse("$baseUrl/decks/$deckId"),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        },
        body: jsonEncode(deckUpdateRequest));
  }
}
