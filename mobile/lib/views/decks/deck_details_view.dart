import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_update_request.dart';

import 'package:mobile/models/deck.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/add_card_view.dart';
import 'package:mobile/views/decks/edit_card_view.dart';
import 'package:mobile/views/settings/premium_upgrade_view.dart';
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
        actions: [
          helpDialog(context),
        ],
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
                      height: 20,
                    ),
                    Expanded(
                      child: deck.cards.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " Number of cards: ${deck.cards.length.toString()}",
                                ),
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
                      height: 20,
                    ),
                    buttonsRow(deck, context),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  GestureDetector helpDialog(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Center(
                  child: Text("Deck Details Help",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "You can add new cards to your decks from here.\n\n"
                    "Tap the card to edit it, tap the red circle icon to remove it.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.help_outline_outlined),
        ));
  }

  Row buttonsRow(Deck deck, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            await showDeletionConfirmationDialog(deck, context);
          },
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(Colors.red),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.013),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size.fromWidth(
                MediaQuery.sizeOf(context).width * 0.4,
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete),
              SizedBox(
                width: 5,
              ),
              Text("Delete Deck"),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => cardLimitExceeded(deck.cards.length)
              ? cardLimitExceededDialog()
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCardView(
                      currentCardCount: deck.cards.length,
                      onAdd: (CardDto cardDto) async {
                        final newCard =
                            await CardService().createCard(deck.id, cardDto);
                        setState(() {
                          deck.cards.add(newCard);
                        });
                      },
                    ),
                  ),
                ),
          style: ButtonStyle(
            backgroundColor: cardLimitExceeded(deck.cards.length)
                ? const WidgetStatePropertyAll(
                    Color.fromARGB(255, 192, 192, 192))
                : const WidgetStatePropertyAll(Colors.blue),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.013),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size.fromWidth(
                MediaQuery.sizeOf(context).width * 0.4,
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle),
              SizedBox(
                width: 5,
              ),
              Text("Add Cards"),
            ],
          ),
        ),
      ],
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
                          textAlign: TextAlign.center,
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
        _deckNameError = "You already have a deck named $deckName";
      });
      return;
    }

    await DeckService().updateDeck(
      deck.id,
      DeckUpdateRequest(name: deckName, userId: CurrentUser.userId!),
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
                  await CardService().editCard(card.id, cardDto);
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

  bool cardLimitExceeded(int cardCount) {
    return cardCount == 20 && !CurrentUser.isPremium!;
  }

  void cardLimitExceededDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Card Limit Exceeded",
                textAlign: TextAlign.center,
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "You have exceeded the limit of 20 cards per deck.\nUpgrade to premium version to create more decks",
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PremiumUpgradeView()));
                      },
                      child: const Text("Upgrade"),
                    ),
                  ],
                )
              ],
            ));
  }
}
