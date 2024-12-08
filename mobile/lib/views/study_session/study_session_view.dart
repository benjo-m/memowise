import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/models/deck.dart';
import 'package:mobile/models/card.dart' as models;
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/views/study_session/study_session_results_view.dart';

class StudySessionView extends StatefulWidget {
  const StudySessionView({super.key, required this.deck});
  final Deck deck;

  @override
  State<StudySessionView> createState() => _StudySessionViewState();
}

class _StudySessionViewState extends State<StudySessionView> {
  late List<models.Card> cards = widget.deck.cards
      .where((card) => card.dueDate.isBefore(DateTime.now()))
      .toList();

  int currentCard = 0;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study"),
        centerTitle: true,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(cards[currentCard].question),
            showAnswer
                ? Text(cards[currentCard].answer)
                : ElevatedButton(
                    onPressed: () {
                      setState(() => showAnswer = true);
                    },
                    child: const Text("Show answer")),
            if (showAnswer)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(0);
                    },
                    child: const Text("0"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(1);
                    },
                    child: const Text("1"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(2);
                    },
                    child: const Text("2"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(3);
                    },
                    child: const Text("3"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(4);
                    },
                    child: const Text("4"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(5);
                    },
                    child: const Text("5"),
                  ),
                ],
              ),
          ]),
    );
  }

  void selectAnswer(int q) {
    var card = cards[currentCard];

    // correct answer
    if (q >= 3) {
      if (card.repetitions == 0) {
        card.interval = 1;
      } else if (card.repetitions == 1) {
        card.interval = 6;
      } else {
        card.interval = (card.interval * card.easeFactor).round();
      }
      // incorrect answer
    } else {
      card.repetitions = 0;
      card.interval = 1;
    }

    var newEf = card.easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    card.easeFactor = double.parse(newEf.toStringAsFixed(2));

    if (currentCard == cards.length - 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StudySessionResultsView(
                    cards: cards,
                  )));
    } else {
      setState(() {
        currentCard++;
        showAnswer = false;
      });
    }
  }
}
