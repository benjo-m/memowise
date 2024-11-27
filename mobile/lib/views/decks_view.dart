import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/models/card.dart';
import 'package:mobile/services/deck_service.dart';

import '../models/deck.dart';

class DecksView extends StatefulWidget {
  const DecksView({super.key});

  @override
  State<DecksView> createState() => _DecksViewState();
}

class _DecksViewState extends State<DecksView> {
  late Future<List<Deck>> futureDecks;

  @override
  void initState() {
    super.initState();
    futureDecks = DeckService().getDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Decks"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () async =>
                    await DeckService().createDeck("Jos noviji deck"),
                child: const Text("Create new deck"),
              ),
              FutureBuilder(
                future: futureDecks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data!
                            .map((deck) => Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: DeckListItem(
                                  name: deck.name,
                                  newCards: deck.cards
                                      .where((card) =>
                                          card.status == CardStatus.New)
                                      .length,
                                  learningCards: deck.cards
                                      .where((card) =>
                                          card.status == CardStatus.Learning)
                                      .length,
                                  learnedCards: deck.cards
                                      .where((card) =>
                                          card.status == CardStatus.Learned)
                                      .length,
                                )))
                            .toList());
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ));
  }
}

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.name,
    required this.newCards,
    required this.learningCards,
    required this.learnedCards,
  });

  final String name;
  final int newCards;
  final int learningCards;
  final int learnedCards;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 160, 190, 243),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              "New: $newCards",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Learning: $learningCards",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Learned: $learnedCards",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
