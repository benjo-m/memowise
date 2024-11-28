import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/models/card.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/deck_details_view.dart';

import '../models/deck.dart';

class DecksView extends StatefulWidget {
  const DecksView({super.key});

  @override
  State<DecksView> createState() => _DecksViewState();
}

class _DecksViewState extends State<DecksView> {
  late Future<List<DeckSummary>> futureDecks;

  @override
  void initState() {
    super.initState();
    futureDecks = DeckService().getDecks();
  }

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
              const SearchBar(
                leading: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
                hintText: "Search decks",
              ),
              const SizedBox(
                height: 40,
              ),
              FutureBuilder(
                future: futureDecks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final decks = snapshot.data!;

                    return Column(
                      children: [
                        CarouselSlider(
                            items: decks
                                .map((deck) => DeckListItem(
                                    deckSummary: deck,
                                    onDelete: () => {
                                          setState(() {
                                            futureDecks =
                                                DeckService().getDecks();
                                          })
                                        }))
                                .toList(),
                            options: CarouselOptions(
                              enableInfiniteScroll: true,
                              enlargeCenterPage: true,
                              height: 350,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("${decks.length} decks"),
                        ),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  await DeckService().createDeck("Jos noviji deck");
                  setState(() {
                    futureDecks = DeckService().getDecks();
                  });
                },
                child: const Text("Create new deck"),
              ),
            ],
          ),
        ));
  }
}

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.deckSummary,
    required this.onDelete,
  });

  final DeckSummary deckSummary;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 160, 190, 243),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  deckSummary.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "New: ${deckSummary.newCards}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Learning: ${deckSummary.learningCards}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Learned: ${deckSummary.learnedCards}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await DeckService().deleteDeck(deckSummary.id);
                  onDelete();
                },
                child: const Text("Delete deck"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
