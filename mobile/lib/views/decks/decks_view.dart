import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks/create_deck_view.dart';
import 'package:mobile/views/decks/deck_details_view.dart';
import 'package:mobile/views/decks/generate_deck_view.dart';
import 'package:mobile/widgets/deck_list_item.dart';

class DecksView extends StatefulWidget {
  const DecksView({super.key});

  @override
  State<DecksView> createState() => _DecksViewState();
}

class _DecksViewState extends State<DecksView> {
  late Future<List<DeckSummary>> _decksFuture;
  final _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _decksFuture = DeckService().getDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Decks"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SearchBar(
                backgroundColor: const WidgetStatePropertyAll(
                  Color.fromARGB(255, 240, 240, 240),
                ),
                side: const WidgetStatePropertyAll(BorderSide(
                  width: 3,
                  color: Color.fromARGB(255, 197, 197, 197),
                )),
                controller: _searchBarController,
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 116, 116, 116),
                  ),
                ),
                hintText: "Search decks",
                elevation: WidgetStateProperty.all(0),
                constraints: const BoxConstraints(
                  maxHeight: 50,
                  minHeight: 50,
                ),
                onChanged: (value) {
                  setState(() {
                    _decksFuture = DeckService().getDecks();
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
              FutureBuilder(
                future: _decksFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final decks = snapshot.data!.where((d) => d.name
                        .toLowerCase()
                        .startsWith(_searchBarController.text));
                    return decks.isNotEmpty
                        ? Column(
                            children: [
                              showCarousel(decks, context),
                              decks.length > 1
                                  ? Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "${decks.length} decks",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 36, 36, 36),
                                        ),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(
                                        "1 deck",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 36, 36, 36),
                                        ),
                                      ),
                                    ),
                            ],
                          )
                        : noDecksMessage();
                  }
                  return const SizedBox(
                    height: 423,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateDeckView())).then(
                            (value) => setState(() {
                              _decksFuture = DeckService().getDecks();
                            }),
                          );
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Color(0xff03AED2)),
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
                            Icon(Icons.style_rounded),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Create deck"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GenerateDeckView())).then(
                        (value) => setState(() {
                          _decksFuture = DeckService().getDecks();
                        }),
                      );
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff03AED2)),
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
                        Icon(Icons.auto_awesome_rounded),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Generate deck"),
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
                  child: DeckListItem(
                    deckSummary: deck,
                  ),
                ))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 370,
          padEnds: true,
          viewportFraction: 0.75,
        ));
  }

  SizedBox noDecksMessage() {
    return const SizedBox(
      height: 423,
      child: Column(
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
          ),
        ],
      ),
    );
  }
}
