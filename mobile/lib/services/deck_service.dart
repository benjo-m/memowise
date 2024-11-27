import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';

class DeckService {
  final String baseUrl = 'https://localhost:7251/decks';

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

  Future<void> createDeck(String name) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    await http.post(Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(DeckCreateRequest(name: name)));
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
}
