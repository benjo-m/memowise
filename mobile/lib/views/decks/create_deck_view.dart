import 'package:flutter/material.dart';
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/add_card_view.dart';
import 'package:mobile/views/decks/add_card_view2.dart';
import 'package:mobile/widgets/add_card_dialog.dart';
import 'package:mobile/widgets/card_list_item.dart';
import 'package:mobile/widgets/edit_card_dialog.dart';

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
        title: const Text("Create deck"),
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
                  } else if (value.trim().length > 100) {
                    return "Deck name must be 100 characters or fewer";
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
                            "Tap the 'New Card' button to create a new card"),
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
                          builder: (context) => const AddCardView2()),
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
                        Text("New Card"),
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
        onEdit: () => showEditCardDialog(context, i),
        onDelete: () => setState(() => _cards.removeAt(i)),
      ));
    }

    return cards;
  }

  void showAddCardDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AddCardDialog(
              onAdd: (CardDto cardDto) {
                if (cardDto.question.isNotEmpty || cardDto.answer.isNotEmpty) {
                  setState(() => _cards.add(cardDto));
                }
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            ));
  }

  void showEditCardDialog(BuildContext context, int cardIndex) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditCardDialog(
            question: _cards[cardIndex].question,
            answer: _cards[cardIndex].answer,
            onCancel: () => Navigator.pop(context),
            onEdit: (CardDto cardDto) {
              setState(() {
                _cards[cardIndex] = cardDto;
                Navigator.pop(context);
              });
            }));
  }
}
