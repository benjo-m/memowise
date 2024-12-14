import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_update_request.dart';

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
  final _deckNameController = TextEditingController();
  bool _editingDeckName = false;
  late FocusNode deckNameFocusNode;

  @override
  void initState() {
    super.initState();
    _deckFuture = DeckService().getDeckById(widget.deckId);
    deckNameFocusNode = FocusNode();
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
              _deckNameController.text = deck.name;
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            focusNode: deckNameFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              border: InputBorder.none,
                              fillColor:
                                  const Color.fromARGB(255, 233, 233, 233),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            controller: _deckNameController,
                            enabled: _editingDeckName,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _editingDeckName
                              ? GestureDetector(
                                  onTap: () async {
                                    deck.name = _deckNameController.text;
                                    await DeckService().updateDeck(
                                        deck.id,
                                        DeckUpdateRequest(
                                            name: _deckNameController.text));
                                    setState(() {
                                      _editingDeckName = false;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.done,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _editingDeckName = true;
                                    });
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      deckNameFocusNode.requestFocus();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(
                      child: ListView(
                        children: cardListItems(deck, context),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AddCardDialog(
                          onAdd: (CardDto cardDto) async {
                            final createdCard = await CardService()
                                .createCard(deck.id, cardDto);
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
                ),
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
