import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/stats_response.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/user_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/widgets/card_ratings_bar_chart.dart';
import 'package:mobile/widgets/most_studied_deck_bar_chart.dart';

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final Future<StatsResponse> _statsFuture =
      UserService().getStats(CurrentUser.userId!);

  TextStyle regularTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 82, 82, 82),
    height: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stats"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: FutureBuilder(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  log(snapshot.error!.toString());
                }
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Decks Stats",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Decks created: ${stats.totalDecksCreated}",
                              style: regularTextStyle,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            pieChart(stats),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Average deck size: ${stats.averageDeckSize} cards",
                              style: regularTextStyle,
                            ),
                            stats.mostStudiedDecks.isNotEmpty
                                ? Text(
                                    "Favorite deck: ${stats.mostStudiedDecks[0].deckName} (studied ${stats.mostStudiedDecks[0].timesStudied} times)",
                                    style: regularTextStyle,
                                  )
                                : Text(
                                    "Favorite deck: No Data",
                                    style: regularTextStyle,
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 236, 249, 255),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: MostStudiedDeckBarChart(
                                      decks: stats.mostStudiedDecks,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Most Studied Decks",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 82, 82, 82),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Cards Stats",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cards created: ${stats.totalCardsCreated}",
                              style: regularTextStyle,
                            ),
                            Text(
                              "Cards reviewed: ${stats.totalCardsLearned}",
                              style: regularTextStyle,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 236, 249, 255),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: CardRatingsBarChart(
                                      cardsRated1: stats.totalCardsRated1,
                                      cardsRated2: stats.totalCardsRated2,
                                      cardsRated3: stats.totalCardsRated3,
                                      cardsRated4: stats.totalCardsRated4,
                                      cardsRated5: stats.totalCardsRated5,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Card Ratings Distribution",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 82, 82, 82),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          "Study Stats",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time spent studying: ${formatDuration(stats.timeSpentStudying)}",
                              style: regularTextStyle,
                            ),
                            Text(
                              "Current study streak: ${stats.currentStudyStreak}",
                              style: regularTextStyle,
                            ),
                            Text(
                              "Longest study streak: ${stats.longestStudyStreak}",
                              style: regularTextStyle,
                            ),
                            Text(
                              "Longest study session: ${formatDuration(stats.longestStudySession)}",
                              style: regularTextStyle,
                            ),
                            Text(
                              "Average study session duration: ${formatDuration(stats.averageStudySessionDuration.toInt())}",
                              style: regularTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              }),
        ));
  }

  Container pieChart(StatsResponse stats) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 236, 249, 255),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              indicator(Colors.greenAccent, "Manually"),
              indicator(Colors.blueAccent, "Generated"),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Column(
            children: [
              SizedBox(
                  height: 150,
                  child: stats.totalDecksCreated > 0
                      ? PieChart(
                          PieChartData(
                            sections: pieChartSections(
                                stats.totalDecksCreatedManually,
                                stats.totalDecksGenerated),
                            sectionsSpace: 0,
                            startDegreeOffset: 90,
                            centerSpaceRadius: 40,
                          ),
                        )
                      : const Center(child: Text("0 decks created"))),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Deck Creation Breakdown",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 82, 82, 82),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> pieChartSections(
      int totalDecksCreatedManually, int totalDecksGenerated) {
    int total = totalDecksCreatedManually + totalDecksGenerated;
    int percentageCreatedManually =
        total > 0 ? ((totalDecksCreatedManually / total) * 100).round() : 0;
    int percentageGenerated =
        total > 0 ? ((totalDecksGenerated / total) * 100).round() : 0;
    return <PieChartSectionData>[
      PieChartSectionData(
        title: "${percentageCreatedManually.toString()}%",
        value: double.parse(totalDecksCreatedManually.toString()),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.greenAccent,
      ),
      PieChartSectionData(
        title: "${percentageGenerated.toString()}%",
        value: double.parse(
          totalDecksGenerated.toString(),
        ),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.blueAccent,
      ),
    ];
  }

  Row indicator(Color color, String label) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          height: 14,
          width: 14,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
        ),
      ],
    );
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} hours';
    } else {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} minutes';
    }
  }
}
