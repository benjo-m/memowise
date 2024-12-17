import 'package:flutter/material.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/deck.dart';
import 'package:mobile/models/card.dart' as models;
import 'package:mobile/models/study_session.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/sm2.dart';
import 'package:mobile/services/study_session_service.dart';
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
  final stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    stopwatch.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Study"),
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
    card.updateCardStats(cardStatsUpdateRequest);

    if (q >= 4) {
      setState(() {
        cardStatsList.add(cardStatsUpdateRequest);
        cards.remove(card);
        showAnswer = false;
        if (cards.isEmpty) {
          finishStudySession();
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

  void finishStudySession() async {
    stopwatch.stop();
    final studySession = StudySession(
      userId: CurrentUser.userId!,
      duration: stopwatch.elapsed.inSeconds,
      cardCount: cardStatsList.length,
      averageEaseFactor: double.parse((cardStatsList.fold(
                  0.0, (sum, cardStats) => sum + cardStats.easeFactor) /
              cardStatsList.length)
          .toStringAsFixed(2)),
      averageRepetitions: double.parse((cardStatsList.fold(
                  0.0, (sum, cardStats) => sum + cardStats.repetitions) /
              cardStatsList.length)
          .toStringAsFixed(2)),
      studiedAt: DateTime.now(),
    );

    await StudySessionService().saveSession(studySession);
    await CardService().updateCardStats(cardStatsList);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudySessionResultsView(
            studySession: studySession,
          ),
        ));
  }
}
