import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/add_card_view.dart';
import 'package:mobile/views/decks/edit_card_view.dart';
import 'package:mobile/views/settings/premium_upgrade_view.dart';
import 'package:mobile/widgets/card_list_item.dart';

class CreateDeckView extends StatefulWidget {
  const CreateDeckView({
    super.key,
    required this.decks,
  });

  final List<DeckSummary> decks;

  @override
  State<CreateDeckView> createState() => _CreateDeckViewState();
}

class _CreateDeckViewState extends State<CreateDeckView> {
  final _formKey = GlobalKey<FormState>();
  final _deckNameController = TextEditingController();
  final List<CardDto> _cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Deck"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: _deckNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Deck name is required";
                  } else if (widget.decks.any((deck) => deck.name == value)) {
                    return "You already have a deck named $value";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text("Deck Name"),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLength: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _cards.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" Number of cards: ${_cards.length.toString()}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView(
                              children: cardListItems(),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                            "Tap the 'Add Cards' button to start adding cards"),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              buttonsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Row buttonsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async => await createDeck(context),
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              Colors.greenAccent,
            ),
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
              Icon(Icons.done),
              SizedBox(
                width: 5,
              ),
              Text("Create Deck"),
            ],
          ),
        ),
        TextButton(
          onPressed: () => cardLimitExceeded()
              ? cardLimitExceededDialog()
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCardView(
                        currentCardCount: _cards.length,
                        onAdd: (CardDto cardDto) {
                          setState(() => _cards.add(cardDto));
                        }),
                  ),
                ),
          style: ButtonStyle(
            backgroundColor: cardLimitExceeded()
                ? const WidgetStatePropertyAll(
                    Color.fromARGB(255, 192, 192, 192))
                : const WidgetStatePropertyAll(Colors.lightBlue),
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

  Future<void> createDeck(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await DeckService().createDeck(DeckCreateRequest(
          name: _deckNameController.text.trim(), cards: _cards));
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  List<Widget> cardListItems() {
    List<Widget> cards = [];

    for (var i = 0; i < _cards.length; i++) {
      cards.add(CardListItem(
        question: _cards[i].question,
        answer: _cards[i].answer,
        onEdit: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditCardView(
              cardDto: _cards[i],
              onEdit: (CardDto cardDto) {
                setState(() {
                  _cards[i] = cardDto;
                });
              },
            ),
          ),
        ),
        onDelete: () => setState(() => _cards.removeAt(i)),
      ));
    }

    return cards;
  }

  bool cardLimitExceeded() {
    return _cards.length == 20 && !CurrentUser.isPremium!;
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
