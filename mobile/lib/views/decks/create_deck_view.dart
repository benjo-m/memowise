import 'package:flutter/material.dart';
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/add_card_view.dart';
import 'package:mobile/views/decks/edit_card_view.dart';
import 'package:mobile/widgets/card_list_item.dart';

class CreateDeckView extends StatefulWidget {
  const CreateDeckView({super.key});

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
                  } else if (value.trim().length > 50) {
                    return "Deck name must be 50 characters or fewer";
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
              ),
              const SizedBox(
                height: 30,
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
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async => await createDeck(context),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 95, 197, 98),
                      ),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      fixedSize: WidgetStatePropertyAll(Size(150, 45)),
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
                        Icon(Icons.done),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Create Deck"),
                      ],
                    ),
                  ),
                  TextButton(
                    // onPressed: () => showAddCardDialog(context),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCardView(onAdd: (CardDto cardDto) {
                          setState(() => _cards.add(cardDto));
                        }),
                      ),
                    ),
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color(blue)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
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
                        Text("Add Cards"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
}
