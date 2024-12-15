import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/deck_details_view.dart';

class GenerateDeckView extends StatefulWidget {
  const GenerateDeckView({super.key});

  @override
  State<GenerateDeckView> createState() => _GenerateDeckViewState();
}

class _GenerateDeckViewState extends State<GenerateDeckView> {
  final _formKey = GlobalKey<FormState>();
  final _deckNameController = TextEditingController();
  final _topicController = TextEditingController();
  final _cardCountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cardCountController.value = const TextEditingValue(text: "10");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Deck"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _deckNameController,
                    decoration: const InputDecoration(
                      label: Text("Deck name"),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Deck name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      label: Text("Topic"),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Topic is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _cardCountController,
                    decoration: const InputDecoration(
                      label: Text("Number of cards"),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Number of cards must be specified";
                      }
                      if (int.parse(value) < 1 || int.parse(value) > 20) {
                        return "Number of cards must be a number between 1 and 20";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await generateDeck(context);
              },
              child: const Text("Generate Deck"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateDeck(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final response = await CardService().generateCards(
        GenerateCardsRequest(
            topic: _topicController.text,
            cardCount: int.parse(_cardCountController.text)),
      );

      if (response.cards.isEmpty && context.mounted) {
        showDialog(
            context: context,
            builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleDialog(
                    title: const Text("Deck generation failed"),
                    children: [
                      const Text(
                          "Could not generate deck for the provided topic. Please enter a different topic and try again."),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Ok"))
                    ],
                  ),
                ));
      } else {
        final createDeckResponse = await DeckService().createDeck(
            DeckCreateRequest(
                name: _deckNameController.text, cards: response.cards));

        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DeckDetailsView(deckId: createDeckResponse.id)));
        }
      }
    }
  }
}
