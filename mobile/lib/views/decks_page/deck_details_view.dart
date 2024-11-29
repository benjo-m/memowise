import 'package:flutter/material.dart';

import 'package:mobile/models/deck.dart';
import 'package:mobile/services/deck_service.dart';

class DeckDetailsView extends StatefulWidget {
  const DeckDetailsView({
    required this.deckId,
    super.key,
  });

  final int deckId;

  @override
  State<DeckDetailsView> createState() => _DeckDetailsViewState();
}

class _DeckDetailsViewState extends State<DeckDetailsView> {
  late Future<Deck> futureDeck;

  @override
  void initState() {
    super.initState();
    futureDeck = DeckService().getDeckById(widget.deckId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: futureDeck,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            return const CircularProgressIndicator();
          },
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: futureDeck,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Deck deck = snapshot.data!;

              return Column(
                children: [
                  Text(deck.name),
                  Column(
                    children: deck.cards
                        .map((card) => Text(
                            "question: ${card.question} answer: ${card.answer}"))
                        .toList(),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await DeckService().deleteDeck(deck.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Delete Deck"))
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
