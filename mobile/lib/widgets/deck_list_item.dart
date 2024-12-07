import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/deck_summary_response.dart';
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/study_session/study_session_view.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.deckSummary,
  });

  final DeckSummary deckSummary;

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
          padding: const EdgeInsets.all(15.0),
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
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Reviewing: ${deckSummary.learnedCards}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Learned: ${deckSummary.learnedCards}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final deck =
                        await DeckService().getDeckById(deckSummary.id);
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudySessionView(deck: deck)));
                    }
                  },
                  child: const Text("Study Deck"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
