import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:mobile/models/deck.dart';
import 'package:mobile/models/card.dart' as models;
import 'package:mobile/models/study_session.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/card_service.dart';
import 'package:mobile/services/sm2.dart';
import 'package:mobile/services/study_session_service.dart';
import 'package:mobile/styles.dart';
import 'package:mobile/views/main_view.dart';
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
  List<models.Card> reviewedCards = List.empty(growable: true);
  int currentCardIndex = 0;
  bool showAnswer = false;
  final stopwatch = Stopwatch();
  int cardsRated1 = 0;
  int cardsRated2 = 0;
  int cardsRated3 = 0;
  int cardsRated4 = 0;
  int cardsRated5 = 0;
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
          leading: showQuitDialog(context),
          actions: [
            showHelpDialog(context),
          ],
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
                                  color: primaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 3.0, color: primaryBorderColor),
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
                                          ? InstaImageViewer(
                                              child: Image.memory(
                                                cachedQuestionImageBytes!,
                                                height: 200,
                                              ),
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
                                        color: primaryBackgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 3.0,
                                            color: primaryBorderColor),
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
                                                ? InstaImageViewer(
                                                    child: Image.memory(
                                                      cachedAnswerImageBytes!,
                                                      height: 200,
                                                    ),
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
                          : ElevatedButton(
                              onPressed: () {
                                setState(() => showAnswer = true);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    const WidgetStatePropertyAll(Colors.blue),
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

  GestureDetector showQuitDialog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cards.isEmpty
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainView()),
                (route) => false)
            : showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Center(child: Text("Quit Session?")),
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Are you sure you want to quit this study session?",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (reviewedCards.isNotEmpty) {
                                    finishStudySession(context);
                                  }
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainView()),
                                      (route) => false);
                                },
                                child: const Text("Yes"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  );
                });
      },
      child: const Icon(Icons.arrow_back),
    );
  }

  Wrap showRatingButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              cardsRated1++;
            });
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
            setState(() {
              cardsRated2++;
            });
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
            setState(() {
              cardsRated3++;
            });
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
            setState(() {
              cardsRated4++;
            });
            selectAnswer(4);
          },
          style: const ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 146, 226, 76)),
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
            setState(() {
              cardsRated5++;
            });
            selectAnswer(5);
          },
          style: const ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 146, 226, 76)),
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

  void selectAnswer(int q) async {
    var card = cards[currentCardIndex];
    var cardStatsUpdateRequest = SM2().sm2(q, card);
    card.updateCardStats(cardStatsUpdateRequest);
    await CardService().updateCardStats(cardStatsUpdateRequest);

    if (q >= 4) {
      setState(() {
        reviewedCards.add(card);
        cards.remove(card);
        showAnswer = false;
        if (cards.isEmpty) {
          finishStudySession(context);
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

  void finishStudySession(BuildContext context) async {
    stopwatch.stop();
    final studySession = StudySession(
      userId: CurrentUser.userId!,
      deckId: widget.deck.id,
      duration: stopwatch.elapsed.inSeconds,
      cardCount: reviewedCards.length,
      averageEaseFactor: double.parse((reviewedCards.fold(
                  0.0, (sum, card) => sum + card.cardStats.easeFactor) /
              reviewedCards.length)
          .toStringAsFixed(2)),
      averageRepetitions: double.parse((reviewedCards.fold(
                  0.0, (sum, card) => sum + card.cardStats.repetitions) /
              reviewedCards.length)
          .toStringAsFixed(2)),
      studiedAt: DateTime.now(),
      cardsRated1: cardsRated1,
      cardsRated2: cardsRated2,
      cardsRated3: cardsRated3,
      cardsRated4: cardsRated4,
      cardsRated5: cardsRated5,
    );

    await StudySessionService().saveSession(studySession);

    if (context.mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudySessionResultsView(
              studySession: studySession,
            ),
          ));
    }
  }

  GestureDetector showHelpDialog(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Center(
                  child: Text("Study Sessions Help",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "This is the Study Session View.\n\n"
                    "Here you will be shown cards from a selected deck.\n\n"
                    "You answer the question in your head (you don't enter the answer anywhere),\n"
                    "then tap the \"Show Answer\" button.\n\n"
                    "Next, the rating buttons will appear.\n"
                    "Rate the answer you gave, and go to the next question\n\n"
                    "It is important that you rate your answers honestly because that is how\n"
                    "the SM2 algorithm calculates the interval after which the card will appear again.",
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Close",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.help_outline_outlined),
        ));
  }
}
