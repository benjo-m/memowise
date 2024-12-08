import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';

import '../models/deck.dart';

class DeckService {
  // final String baseUrl = 'http://10.0.2.2:5151/api/decks';
  final String baseUrl = 'http://localhost:5151/api/decks';

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
}
