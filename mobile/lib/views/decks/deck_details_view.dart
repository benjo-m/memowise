import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';

import 'package:mobile/models/deck.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/widgets/add_card_dialog.dart';
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
  late Future<Deck> _deckFuture;

  @override
  void initState() {
    super.initState();
    _deckFuture = DeckService().getDeckById(widget.deckId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deck Details"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _deckFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Deck deck = snapshot.data!;
              return Column(
                children: [
                  Text(deck.name),
                  Column(
                    children: cardListItems(deck, context),
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AddCardDialog(
                        onAdd: (CardDto cardDto) async {
                          final createdCard =
                              await CardService().createCard(deck.id, cardDto);
                          setState(() => deck.cards.add(createdCard));
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    ),
                    child: const Text("New Card"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await DeckService().deleteDeck(deck.id);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Delete Deck"),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<CardListItem> cardListItems(Deck deck, BuildContext context) {
    List<CardListItem> cardListItems = [];

    for (int i = 0; i < deck.cards.length; i++) {
      var card = deck.cards[i];
      cardListItems.add(
        CardListItem(
          question: card.question,
          onEdit: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => EditCardDialog(
                question: card.question,
                answer: card.answer,
                onEdit: (CardDto cardDto) async {
                  await CardService().editCard(deck.id, card.id, cardDto);
                  final cardToEdit = deck.cards[i];
                  cardToEdit.question = cardDto.question;
                  cardToEdit.answer = cardDto.answer;
                  setState(() {
                    deck.cards[i] = cardToEdit;
                  });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                onCancel: () => Navigator.pop(context),
              ),
            );
          },
          onDelete: () async {
            final deletedCard = await CardService().deleteCard(card.id);
            setState(
                () => deck.cards.removeWhere((c) => c.id == deletedCard.id));
          },
        ),
      );
    }

    return cardListItems;
  }
}
