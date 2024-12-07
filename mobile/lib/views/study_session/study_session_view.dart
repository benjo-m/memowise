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
                    child: const Text("Don't know"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(0);
                    },
                    child: const Text("Hard"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(1);
                    },
                    child: const Text("Medium"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectAnswer(2);
                    },
                    child: const Text("Easy"),
                  ),
                ],
              ),
          ]),
    );
  }

  void selectAnswer(int days) {
    if (currentCard == cards.length - 1) {
      setState(() {
        currentCard = 0;
        showAnswer = false;
      });
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => StudySessionResultsView()));
    } else {
      setState(() {
        cards[currentCard].dueDate =
            cards[currentCard].dueDate.add(Duration(days: days));
        currentCard++;
        showAnswer = false;
      });
    }
  }
}
