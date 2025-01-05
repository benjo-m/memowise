import 'dart:developer';

import 'package:desktop/dto/analytics_data.dart';
import 'package:desktop/services/analytics_service.dart';
import 'package:desktop/widgets/deck_creation_chart.dart';
import 'package:desktop/widgets/new_users_by_month_chart.dart';
import 'package:desktop/widgets/study_times_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  final _yearController = TextEditingController();
  Future<AnalyticsData> _analyticsFuture =
      AnalyticsService().getAnalyticsData(2024);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Analytics"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: FutureBuilder(
              future: _analyticsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) log(snapshot.error.toString());
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      usersStats(data),
                      Column(
                        children: [
                          NewUsersByMonthChart(
                            newUsersData: data.newUsersByMonth,
                          ),
                          const SizedBox(height: 20),
                          yearDropdown(),
                        ],
                      ),
                      const SizedBox(height: 50),
                      decksCardsStats(data),
                      DeckCreationChart(
                        percentageCreatedManually:
                            data.manuallyCreatedDecksPercentage,
                        percentageGenerated: data.generatedDecksPercentage,
                      ),
                      const SizedBox(height: 50),
                      studySessionsStats(data),
                      StudyTimesChart(
                          studySessionSegments: data.studySessionSegments),
                      const SizedBox(height: 50),
                      achievementsUnlockPercentages(data),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Column achievementsUnlockPercentages(AnalyticsData data) {
    return Column(
      children: data.achievementUnlockPercentages
          .map((achievement) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(achievement.name),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 200,
                    child: Stack(children: [
                      Positioned.fill(
                        child: LinearProgressIndicator(
                          value: achievement.percentage / 100,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "${achievement.percentage}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ]),
                  )
                ],
              ))
          .toList(),
    );
  }

  Column studySessionsStats(AnalyticsData data) {
    return Column(
      children: [
        Text(
          "Total Study Sessions Completed: ${data.totalStudySessions}",
        ),
        Text(
          "Total Time Spent Studying: ${formatTime(data.totalTimeSpentStudying)}",
        ),
        Text(
          "Average Study Session Duration: ${formatTime(data.averageSessionDuration)}",
        ),
        Text(
          "Average Study Streak: ${data.averageStudyStreak}",
        ),
        Text(
          "Longest Study Streak: ${data.longestStudyStreak}",
        ),
      ],
    );
  }

  Column usersStats(AnalyticsData data) {
    return Column(
      children: [
        Text("Total Users: ${data.totalUsers.toString()}"),
        Text("Monthly Active Users: ${data.monthlyActiveUsers.toString()}"),
        Text("Daily Active Users: ${data.dailyActiveUsers.toString()}"),
      ],
    );
  }

  Column decksCardsStats(AnalyticsData data) {
    return Column(
      children: [
        Text(
          "Total Decks Created ${data.totalDecksCreated.toString()}",
        ),
        Text(
          "Total Cards Created ${data.totalCardsCreated.toString()}",
        ),
        Text(
          "Avg Decks per User ${data.averageDecksPerUser.toString()}",
        ),
        Text(
          "Avg Cards per User ${data.averageCardsPerUser.toString()}",
        ),
        Text(
          "Avg Card Ease Factor ${data.averageEaseFactor.toString()}",
        ),
      ],
    );
  }

  DropdownMenu yearDropdown() {
    return DropdownMenu<String>(
      controller: _yearController,
      initialSelection: "2024",
      label: const Text("Year"),
      onSelected: (String? year) {
        setState(() {
          _analyticsFuture =
              AnalyticsService().getAnalyticsData(int.parse(year!));
        });
      },
      dropdownMenuEntries: const <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: "2025", label: "2025"),
        DropdownMenuEntry(value: "2024", label: "2024"),
      ],
    );
  }

  String formatTime(num seconds) {
    if (seconds < 3600) {
      num minutes = (seconds ~/ 60);
      num remainingSeconds = (seconds % 60).toInt();
      return "$minutes:${remainingSeconds.toString().padLeft(2, '0')} minutes";
    } else {
      num hours = (seconds ~/ 3600);
      num remainingMinutes = ((seconds % 3600) ~/ 60).toInt();
      return "$hours:${remainingMinutes.toString().padLeft(2, '0')} hours";
    }
  }
}
