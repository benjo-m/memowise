import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';

import 'package:mobile/models/deck.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/widgets/card_list_item.dart';
import 'package:mobile/widgets/edit_card_dialog.dart';

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
        title: const Text("Deck Details"),
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
                        .map((card) => CardListItem(
                              question: card.question,
                              onEdit: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => EditCardDialog(
                                          cardDto: CardDto(
                                              question: card.question,
                                              answer: card.answer),
                                          onEdit: (CardDto cardDto) async {
                                            await DeckService().editCard(
                                                deck.id, card.id, cardDto);
                                            setState(() {
                                              futureDeck = DeckService()
                                                  .getDeckById(deck.id);
                                            });
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          onCancel: () =>
                                              Navigator.pop(context),
                                        ));
                              },
                              onDelete: () => log("Delete"),
                            ))
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
