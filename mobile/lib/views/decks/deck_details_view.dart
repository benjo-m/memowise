import 'package:flutter/material.dart';
import 'package:mobile/config/constants.dart';
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
                              fontSize: 18,
                            ),
                            controller: _deckNameController,
                            onEditingComplete: () async =>
                                await editDeckName(deck),
                            enabled: _editingDeckName,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        !_editingDeckName
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _editingDeckName = true;
                                  });
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    deckNameFocusNode.requestFocus();
                                  });
                                },
                                style: const ButtonStyle(
                                  fixedSize: WidgetStatePropertyAll(
                                    Size(85, 45),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Color(blue),
                                  ),
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
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
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              )
                            : TextButton(
                                onPressed: () async => await editDeckName(deck),
                                style: const ButtonStyle(
                                  fixedSize: WidgetStatePropertyAll(
                                    Size(85, 45),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Color.fromARGB(255, 95, 197, 98),
                                  ),
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      width: 2,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Done",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                      ],
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
                          onPressed: () => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AddCardDialog(
                              onAdd: (CardDto cardDto) async {
                                if (cardDto.question.isNotEmpty ||
                                    cardDto.answer.isNotEmpty) {
                                  final createdCard = await CardService()
                                      .createCard(deck.id, cardDto);
                                  setState(() => deck.cards.add(createdCard));
                                }
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              onCancel: () => Navigator.pop(context),
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
    String deckName = _deckNameController.text.trim();
    if (deckName.isEmpty || deckName.length > 100) {
      _deckNameController.text = deck.name;
    } else {
      deck.name = _deckNameController.text;
      await DeckService().updateDeck(
          deck.id, DeckUpdateRequest(name: _deckNameController.text));
    }
    setState(() {
      _editingDeckName = false;
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
          onEdit: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => EditCardDialog(
                answer: card.answer,
                question: card.question,
                onEdit: (CardDto cardDto) async {
                  if (cardDto.question.isNotEmpty ||
                      cardDto.answer.isNotEmpty) {
                    await CardService().editCard(deck.id, card.id, cardDto);
                    final cardToEdit = deck.cards[i];
                    cardToEdit.question = cardDto.question;
                    cardToEdit.answer = cardDto.answer;
                    setState(() {
                      deck.cards[i] = cardToEdit;
                    });
                  }
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
