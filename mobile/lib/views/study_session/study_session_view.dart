import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/deck.dart';
import 'package:mobile/models/card.dart' as models;
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
      .where((card) => card.cardStats.dueDate.isBefore(DateTime.now()))
      .toList();
  List<CardStatsUpdateRequest> cardStatsList = List.empty(growable: true);
  int currentCardIndex = 0;
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Study"),
          centerTitle: true,
        ),
        body: cards.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(cards[currentCardIndex].question),
                    showAnswer
                        ? Text(cards[currentCardIndex].answer)
                        : ElevatedButton(
                            onPressed: () {
                              setState(() => showAnswer = true);
                            },
                            child: const Text("Show answer")),
                    if (showAnswer) showRatingButtons(),
                  ])
            : const Center(
                child: Text("No learning cards at the moment"),
              ));
  }

  Row showRatingButtons() {
    return Row(
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
    );
  }

  void selectAnswer(int q) {
    var card = cards[currentCardIndex];
    var cardStatsUpdateRequest = SM2().sm2(q, card);
    card.cardStats.easeFactor = cardStatsUpdateRequest.easeFactor;

    if (q >= 4) {
      setState(() {
        cardStatsList.add(cardStatsUpdateRequest);
        cards.remove(card);
        showAnswer = false;
        if (cards.isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StudySessionResultsView(
                  cards: cardStatsList,
                ),
              ));
        } else if (currentCardIndex > cards.length - 1) {
          setState(() {
            currentCardIndex = 0;
            showAnswer = false;
          });
        }
      });
    } else {
      setState(() {
        if (currentCardIndex == cards.length - 1) {
          currentCardIndex = 0;
        } else {
          currentCardIndex++;
        }
        showAnswer = false;
      });
    }
  }
}
