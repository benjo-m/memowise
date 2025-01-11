import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/dtos/deck_create_request.dart';
import 'package:mobile/dtos/generate_cards_request.dart';
import 'package:mobile/services/auth/current_user.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
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
                      height: 20,
                    ),
                    TextFormField(
                      controller: _topicController,
                      decoration: const InputDecoration(
                        label: Text("Topic"),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Topic is required";
                        } else if (value.trim().length > 100) {
                          return "Topic must be 100 characters of fewer";
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Number of cards must be specified";
                        }
                        if ((int.parse(value) < 1 || int.parse(value) > 10) &&
                            !CurrentUser.isPremium!) {
                          return "Number of cards must be between 1 and 10";
                        }
                        if ((int.parse(value) < 1 || int.parse(value) > 30)) {
                          return "Number of cards must be between 1 and 30";
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async => await generateDeck(context),
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
                    Text("Generate Deck"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> generateDeck(BuildContext context) async {
    Fluttertoast.showToast(
      msg: "Generating deck...",
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: const Color.fromARGB(255, 188, 234, 255),
      textColor: Colors.black,
      fontSize: 16,
    );

    if (_formKey.currentState!.validate()) {
      try {
        final response = await CardService().generateCards(
          GenerateCardsRequest(
              topic: _topicController.text.trim(),
              cardCount: int.parse(_cardCountController.text)),
        );

        if (response.cards.isEmpty && context.mounted) {
          showGenerationFailedDialog(context);
        } else {
          final createDeckResponse = await DeckService().createDeck(
              DeckCreateRequest(
                  name: _deckNameController.text.trim(),
                  cards: response.cards));

          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeckDetailsView(deckId: createDeckResponse.id)));
          }
        }
      } catch (e) {
        if (context.mounted) {
          showGenerationFailedDialog(context);
        }
      }
    }
  }

  void showGenerationFailedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Center(child: Text("Could not generate deck")),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child:
                        Text("Please enter a different topic and try again."),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Ok"),
                    ),
                  ],
                )
              ],
            ));
  }
}
