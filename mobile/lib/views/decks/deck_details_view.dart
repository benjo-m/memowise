import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_update_request.dart';

import 'package:mobile/models/deck.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/add_card_view.dart';
import 'package:mobile/views/decks/edit_card_view.dart';
import 'package:mobile/widgets/card_list_item.dart';

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
  final _deckNameController = TextEditingController();
  late FocusNode _deckNameFocusNode;
  String? _deckNameError;

  @override
  void initState() {
    super.initState();
    _deckFuture = DeckService().getDeckById(widget.deckId);
    _deckNameFocusNode = FocusNode();
    DeckService().getDeckById(widget.deckId).then((deck) {
      setState(() {
        _deckNameController.text = deck.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deck Details"),
      ),
      body: FutureBuilder(
          future: _deckFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Deck deck = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _deckNameFocusNode,
                      maxLength: 50,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Deck Name',
                        errorText: _deckNameError,
                      ),
                      controller: _deckNameController,
                      onEditingComplete: () async => await editDeckName(deck),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: deck.cards.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    " Number of cards: ${deck.cards.length.toString()}"),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView(
                                    children: cardListItems(deck, context),
                                  ),
                                ),
                              ],
                            )
                          : const Center(child: Text("Deck empty")),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await showDeletionConfirmationDialog(deck, context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 243, 83, 71)),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            fixedSize: WidgetStatePropertyAll(Size(150, 45)),
                            side: WidgetStatePropertyAll(
                              BorderSide(
                                width: 2,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Delete Deck"),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCardView(
                                onAdd: (CardDto cardDto) async {
                                  final newCard = await CardService()
                                      .createCard(deck.id, cardDto);
                                  setState(() {
                                    deck.cards.add(newCard);
                                  });
                                },
                              ),
                            ),
                          ),
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(blue)),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white),
                            fixedSize: WidgetStatePropertyAll(Size(150, 45)),
                            side: WidgetStatePropertyAll(
                              BorderSide(
                                width: 2,
                                color: Colors.lightBlue,
                              ),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle),
                              SizedBox(
                                width: 8,
                              ),
                              Text("New Card"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Future<void> showDeletionConfirmationDialog(
      Deck deck, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Center(child: Text("Delete deck?")),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Are you sure you want to delete\n${deck.name}?",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await DeckService().deleteDeck(deck.id);
                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("Yes"),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("No"),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  Future<void> editDeckName(Deck deck) async {
    _deckNameFocusNode.unfocus();
    String deckName = _deckNameController.text.trim();

    final decks = await DeckService().getDecks();

    if (deckName.isEmpty) {
      setState(() {
        _deckNameError = null;
        _deckNameController.text = deck.name;
      });
      return;
    }

    if (deckName == deck.name) {
      setState(() {
        _deckNameError = null;
      });
      return;
    }

    if (decks.any((existingDeck) =>
        existingDeck.name == deckName && existingDeck.id != deck.id)) {
      setState(() {
        _deckNameError = "A deck with that name already exists";
      });
      return;
    }

    await DeckService().updateDeck(
      deck.id,
      DeckUpdateRequest(name: deckName),
    );
    setState(() {
      _deckNameError = null;
    });
  }

  List<CardListItem> cardListItems(Deck deck, BuildContext context) {
    List<CardListItem> cardListItems = [];
    for (int i = 0; i < deck.cards.length; i++) {
      var card = deck.cards[i];
      cardListItems.add(
        CardListItem(
          question: card.question,
          answer: card.answer,
          onEdit: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditCardView(
                cardDto: CardDto.fromCard(card),
                onEdit: (CardDto cardDto) async {
                  await CardService().editCard(deck.id, card.id, cardDto);
                  final cardToEdit = deck.cards[i];
                  cardToEdit.editCard(cardDto);
                  setState(() {
                    deck.cards[i] = cardToEdit;
                  });
                },
              ),
            ),
          ),
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
