import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks_page/deck_details_view.dart';

class GenerateDeckView extends StatefulWidget {
  const GenerateDeckView({super.key});

  @override
  State<GenerateDeckView> createState() => _GenerateDeckViewState();
}

class _GenerateDeckViewState extends State<GenerateDeckView> {
  final _deckNameController = TextEditingController();
  final _topicController = TextEditingController();
  final _cardCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Deck"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _deckNameController,
                    decoration: const InputDecoration(
                      label: Text("Deck name"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownMenu(
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: "Geography", label: "Geography"),
                      DropdownMenuEntry(value: "History", label: "History"),
                      DropdownMenuEntry(value: "Finance", label: "Finance"),
                    ],
                    enableSearch: true,
                    label: const Text("Topic"),
                    controller: _topicController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _cardCountController,
                    decoration: const InputDecoration(
                      label: Text("Number of cards"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await DeckService().generateCards(
                  GenerateCardsRequest(
                      topic: _topicController.text,
                      cardCount: int.parse(_cardCountController.text)),
                );

                final createDeckResponse = await DeckService().createDeck(
                    DeckCreateRequest(
                        name: _deckNameController.text, cards: response.cards));

                if (context.mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeckDetailsView(deckId: createDeckResponse.id)));
                }
              },
              child: const Text("Generate Deck"),
            ),
          ],
        ),
      ),
    );
  }
}
