import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            ? Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "Question",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffFEEFAD),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2.0,
                                    color:
                                        const Color.fromARGB(255, 252, 221, 84),
                                  ),
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  cards[currentCardIndex].question,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          showAnswer
                              ? Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "Answer",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFEEFAD),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 2.0,
                                          color: const Color.fromARGB(
                                              255, 252, 221, 84),
                                        ),
                                      ),
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        cards[currentCardIndex].answer,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                      showAnswer
                          ? const SizedBox()
                          : TextButton(
                              onPressed: () {
                                setState(() => showAnswer = true);
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff03AED2)),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                                fixedSize:
                                    WidgetStatePropertyAll(Size(150, 45)),
                                side: WidgetStatePropertyAll(
                                  BorderSide(
                                    width: 2,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                              child: const Text("Show Answer"),
                            ),
                      if (showAnswer) showRatingButtons(),
                    ]),
              )
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
            selectAnswer(1);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red[500]),
          ),
          child: const Text(
            "1",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            selectAnswer(2);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.orange[500]),
          ),
          child: const Text(
            "2",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            selectAnswer(3);
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
          ),
          child: const Text(
            "3",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            selectAnswer(4);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.lightGreen[500]),
          ),
          child: const Text(
            "4",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            selectAnswer(5);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green[500]),
          ),
          child: const Text(
            "5",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
