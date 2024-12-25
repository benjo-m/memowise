import 'dart:convert';
import 'dart:typed_data';

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

  Uint8List? cachedQuestionImageBytes;
  Uint8List? cachedAnswerImageBytes;

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    if (cards.isNotEmpty) {
      _cacheImages();
    }
  }

  void _cacheImages() {
    if (cards[currentCardIndex].questionImage == null ||
        cards[currentCardIndex].questionImage!.isEmpty) {
      cachedQuestionImageBytes = null;
    }

    if (cards[currentCardIndex].answerImage == null ||
        cards[currentCardIndex].answerImage!.isEmpty) {
      cachedAnswerImageBytes = null;
    }

    cachedQuestionImageBytes =
        base64Decode(cards[currentCardIndex].questionImage ?? "");

    cachedAnswerImageBytes =
        base64Decode(cards[currentCardIndex].answerImage ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Study"),
        ),
        body: cards.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, left: 20, bottom: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  "Question",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.25,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 3.0,
                                  ),
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cards[currentCardIndex].question,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      cachedQuestionImageBytes != null &&
                                              cachedQuestionImageBytes!
                                                  .isNotEmpty
                                          ? Image.memory(
                                              cachedQuestionImageBytes!,
                                              height: 200,
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          showAnswer
                              ? Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Answer",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 3.0,
                                        ),
                                      ),
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cards[currentCardIndex].answer,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            cachedAnswerImageBytes != null &&
                                                    cachedAnswerImageBytes!
                                                        .isNotEmpty
                                                ? Image.memory(
                                                    cachedAnswerImageBytes!,
                                                    height: 200,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
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
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color(0xff03AED2)),
                                foregroundColor:
                                    const WidgetStatePropertyAll(Colors.white),
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.all(
                                      MediaQuery.sizeOf(context).height *
                                          0.014),
                                ),
                                fixedSize: WidgetStatePropertyAll(
                                  Size.fromWidth(
                                    MediaQuery.sizeOf(context).width * 0.4,
                                  ),
                                ),
                                side: const WidgetStatePropertyAll(
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

  Wrap showRatingButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            selectAnswer(5);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.green[500]),
          ),
          child: const Text(
            "5",
            style: TextStyle(
              fontSize: 16,
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
            _cacheImages();
          });
        } else {
          setState(() {
            showAnswer = false;
            _cacheImages();
          });
        }
      });
    } else {
      setState(() {
        if (currentCardIndex == cards.length - 1) {
          currentCardIndex = 0;
          _cacheImages();
        } else {
          currentCardIndex++;
          _cacheImages();
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
