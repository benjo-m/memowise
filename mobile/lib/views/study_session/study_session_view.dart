import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/deck.dart';
import 'package:mobile/models/card.dart' as models;
import 'package:mobile/services/deck_service.dart';
import 'package:mobile/services/sm2.dart';
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
  List<CardStatsUpdateRequest> cardStatsList = List.empty(growable: true);
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
    var cardStatsUpdateRequest = SM2().sm2(q, cards[currentCard]);
    cardStatsList.add(cardStatsUpdateRequest);

    if (currentCard == cards.length - 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudySessionResultsView(
              cards: cardStatsList,
            ),
          ));
    } else {
      setState(() {
        currentCard++;
        showAnswer = false;
      });
    }
  }
}
