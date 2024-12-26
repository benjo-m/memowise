import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/create_deck_view.dart';
import 'package:mobile/views/decks/deck_details_view.dart';
import 'package:mobile/views/decks/generate_deck_view.dart';
import 'package:mobile/views/settings/premium_upgrade_view.dart';
import 'package:mobile/widgets/deck_list_item.dart';

class DecksView extends StatefulWidget {
  const DecksView({super.key});

  @override
  State<DecksView> createState() => _DecksViewState();
}

class _DecksViewState extends State<DecksView> {
  Future<List<DeckSummary>> _decksFuture = DeckService().getDecks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Decks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FutureBuilder(
          future: _decksFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final decks = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  statsRow(decks),
                  decks.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            showCarousel(decks, context),
                          ],
                        )
                      : noDecksMessage(),
                  buttonsRow(decks),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Row statsRow(List<DeckSummary> decks) {
    final totalCards = decks.fold(0, (total, deck) {
      return total + deck.newCards + deck.learnedCards + deck.learningCards;
    });

    final cardToLearn = decks.fold(0, (total, deck) {
      return total + deck.learningCards + deck.newCards;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 3.0,
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text(
                "Total Decks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
              ),
              Text(
                "${decks.length}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.sizeOf(context).height * 0.025,
                  color: decks.length == 10 && !CurrentUser.isPremium!
                      ? Colors.red
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 3.0,
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text(
                "Total Cards",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
              ),
              Text(
                "$totalCards",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.sizeOf(context).height * 0.025,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 3.0,
            ),
          ),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              const Text(
                "  To Learn  ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
              ),
              Text(
                "$cardToLearn",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.sizeOf(context).height * 0.025,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // int totalCards(List<DeckSummary> decks) {
  //   return decks.fold(0, (total, deck) {
  //     return total + deck.newCards + deck.learnedCards + deck.learnedCards;
  //   });
  // }

  Row buttonsRow(List<DeckSummary> decks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => deckLimitExceeded(decks)
              ? deckLimitExceededDialog()
              : createDeck(decks),
          style: ButtonStyle(
            backgroundColor: deckLimitExceeded(decks)
                ? const WidgetStatePropertyAll(
                    Color.fromARGB(255, 192, 192, 192))
                : const WidgetStatePropertyAll(Color(0xff03AED2)),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.013),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size.fromWidth(
                MediaQuery.sizeOf(context).width * 0.4,
              ),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(
                width: 2,
                color: deckLimitExceeded(decks)
                    ? const Color.fromARGB(255, 179, 179, 179)
                    : Colors.lightBlue,
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.style_rounded),
              SizedBox(
                width: 5,
              ),
              Text("Create Deck"),
            ],
          ),
        ),
        TextButton(
          onPressed: () => deckLimitExceeded(decks)
              ? deckLimitExceededDialog()
              : generateDeck(),
          style: ButtonStyle(
            backgroundColor: deckLimitExceeded(decks)
                ? const WidgetStatePropertyAll(
                    Color.fromARGB(255, 192, 192, 192))
                : const WidgetStatePropertyAll(Color(0xff03AED2)),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            padding: WidgetStatePropertyAll(
              EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.013),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size.fromWidth(
                MediaQuery.sizeOf(context).width * 0.4,
              ),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(
                width: 2,
                color: deckLimitExceeded(decks)
                    ? const Color.fromARGB(255, 179, 179, 179)
                    : Colors.lightBlue,
              ),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome_rounded),
              SizedBox(
                width: 5,
              ),
              Text("Generate Deck"),
            ],
          ),
        ),
      ],
    );
  }

  void createDeck(List<DeckSummary> decks) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateDeckView(decks: decks))).then(
      (value) => setState(() {
        _decksFuture = DeckService().getDecks();
      }),
    );
  }

  void generateDeck() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const GenerateDeckView())).then(
      (value) => setState(() {
        _decksFuture = DeckService().getDecks();
      }),
    );
  }

  void deckLimitExceededDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Text(
                "Deck Limit Exceeded",
                textAlign: TextAlign.center,
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "You have exceeded the limit of 10 decks.\nUpgrade to premium version to create more decks",
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
                                    const PremiumUpgradeView())).then((_) {
                          setState(() {
                            _decksFuture = DeckService().getDecks();
                          });
                        });
                      },
                      child: const Text("Upgrade"),
                    ),
                  ],
                )
              ],
            ));
  }

  CarouselSlider showCarousel(
      Iterable<DeckSummary> decks, BuildContext context) {
    return CarouselSlider(
      items: decks
          .map((deck) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeckDetailsView(deckId: deck.id))).then(
                    (value) => setState(() {
                      _decksFuture = DeckService().getDecks();
                    }),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DeckListItem(
                    deckSummary: deck,
                  ),
                ),
              ))
          .toList(),
      options: CarouselOptions(
        height: MediaQuery.sizeOf(context).height * 0.4,
        viewportFraction: 0.7,
      ),
    );
  }

  SizedBox noDecksMessage() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).height * 0.5,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "No decks found!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 78, 78, 78),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "It looks like you don't have any decks yet.\nYou can create one manually or let AI generate a deck for you",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  bool deckLimitExceeded(List<DeckSummary> decks) {
    return decks.length == 10 && !CurrentUser.isPremium!;
  }
}
