import 'dart:async';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/decks_page/deck_create_view.dart';
import 'package:mobile/views/decks_page/deck_details_view.dart';
import 'package:mobile/views/decks_page/generate_deck_view.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Decks"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(35.0),
          child: ListView(
            children: [
              SearchBar(
                controller: _searchBarController,
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                hintText: "Search decks",
                onChanged: (value) {
                  setState(() {
                    _decksFuture = DeckService().getDecks();
                  });
                },
              ),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder(
                stream: FirebaseAuthProvider().authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _decksFuture = DeckService().getDecks();
                    return FutureBuilder(
                      future: _decksFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final decks = snapshot.data!.where((d) => d.name
                              .toLowerCase()
                              .startsWith(_searchBarController.text));
                          return Column(
                            children: [
                              showCarousel(decks, context),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text("${decks.length} decks"),
                              ),
                            ],
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  showNewDeckDialog(context);
                },
                child: const Text("New Deck"),
              ),
            ],
          ),
        ));
  }

  Future<dynamic> showNewDeckDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: const Center(child: Text("New Deck")),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DeckCreateView())).then(
                              (value) => setState(() {
                                _decksFuture = DeckService().getDecks();
                              }),
                            );
                          },
                          child: const Text("Create deck")),
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GenerateDeckView())).then(
                              (value) => setState(() {
                                _decksFuture = DeckService().getDecks();
                              }),
                            );
                          },
                          child: const Text("Generate deck")),
                    ],
                  ),
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
                  child: DeckListItem(
                    deckSummary: deck,
                  ),
                ))
            .toList(),
        options: CarouselOptions(
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          height: 350,
          padEnds: true,
        ));
  }
}
