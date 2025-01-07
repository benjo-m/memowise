import 'dart:developer';

import 'package:desktop/dto/analytics_data.dart';
import 'package:desktop/services/analytics_service.dart';
import 'package:desktop/services/report_service.dart';
import 'package:desktop/widgets/deck_creation_chart.dart';
import 'package:desktop/widgets/new_users_by_month_chart.dart';
import 'package:desktop/widgets/study_times_chart.dart';
import 'package:desktop/widgets/user_distribution_chart.dart';
import 'package:desktop/widgets/user_growth_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  final fontColor = const Color.fromARGB(255, 70, 70, 70);
  final _yearController = TextEditingController();
  var _analyticsFuture = AnalyticsService().getAnalyticsData(2024);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: generateReportButton(),
          )
        ],
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
                  return LayoutBuilder(builder: (context, constraints) {
                    if (MediaQuery.sizeOf(context).width >= 1400) {
                      return Column(
                        children: [
                          userStatsCardsRow(data),
                          const SizedBox(height: 50),
                          userChartsOneRow(data),
                          const SizedBox(height: 50),
                          userChartsTwoRow(data),
                          const SizedBox(height: 50),
                          studySessionStatsRow(data),
                          const SizedBox(height: 50),
                          StudyTimesChart(
                              studySessionSegments: data.studySessionSegments),
                          const SizedBox(height: 50),
                          decksAndCardsStatsCardsRow(data),
                          const SizedBox(height: 50),
                          DeckCreationChart(
                            percentageCreatedManually:
                                data.manuallyCreatedDecksPercentage,
                            percentageGenerated: data.generatedDecksPercentage,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          userStatsCardsWrap(data),
                          const SizedBox(height: 50),
                          userChartsOneWrap(data),
                          const SizedBox(height: 50),
                          userChartsTwoWrap(data),
                          const SizedBox(height: 50),
                          studySessionStatsWrap(data),
                          const SizedBox(height: 50),
                          StudyTimesChart(
                              studySessionSegments: data.studySessionSegments),
                          const SizedBox(height: 50),
                          decksAndCardsStatsCardsWrap(data),
                          const SizedBox(height: 50),
                          DeckCreationChart(
                            percentageCreatedManually:
                                data.manuallyCreatedDecksPercentage,
                            percentageGenerated: data.generatedDecksPercentage,
                          ),
                        ],
                      );
                    }
                  });
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Row userChartsOneRow(AnalyticsData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: UserDistributionChart(
            userDistribution: data.userDistribution,
          ),
        ),
        const SizedBox(width: 50),
        Flexible(
          flex: 2,
          child: Column(
            children: [
              NewUsersByMonthChart(
                newUsersData: data.newUsersByMonth,
              ),
              const SizedBox(
                height: 20,
              ),
              yearDropdown(),
            ],
          ),
        ),
      ],
    );
  }

  Wrap userChartsOneWrap(AnalyticsData data) {
    return Wrap(
      spacing: 50,
      runSpacing: 50,
      children: [
        UserDistributionChart(
          userDistribution: data.userDistribution,
        ),
        Column(
          children: [
            NewUsersByMonthChart(
              newUsersData: data.newUsersByMonth,
            ),
            const SizedBox(
              height: 20,
            ),
            yearDropdown(),
          ],
        ),
      ],
    );
  }

  Row userChartsTwoRow(AnalyticsData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: UserGrowthChart(userGrowth: data.userGrowth),
        ),
        const SizedBox(width: 50),
        Flexible(
          flex: 1,
          child: achievementsUnlockPercentages(data),
        ),
      ],
    );
  }

  Wrap userChartsTwoWrap(AnalyticsData data) {
    return Wrap(
      spacing: 50,
      runSpacing: 50,
      children: [
        UserGrowthChart(userGrowth: data.userGrowth),
        achievementsUnlockPercentages(data),
      ],
    );
  }

  TextButton generateReportButton() {
    return TextButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blueAccent),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: () async {
          final pdfFile = await ReportService.generateReport(
              await AnalyticsService()
                  .getAnalyticsData(int.parse(_yearController.text)));
          ReportService.openFile(pdfFile);
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(FontAwesomeIcons.solidFileLines),
              SizedBox(
                width: 5,
              ),
              Text("Generate Report"),
            ],
          ),
        ));
  }

  Container achievementsUnlockPercentages(AnalyticsData data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const Text(
            "User Unlock Rates for Achievements",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.42,
            constraints: const BoxConstraints(
              minHeight: 319,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...data.achievementUnlockPercentages.map((achievement) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
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
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Container statCard({
    required String title,
    required String quantity,
  }) {
    return Container(
      width: 250,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: fontColor,
              fontSize: 16,
            ),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Row userStatsCardsRow(AnalyticsData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard(
          title: "Total Users",
          quantity: data.totalUsers.toString(),
        ),
        statCard(
          title: "PETA KARTICA",
          quantity: "0000000",
        ),
        statCard(
          title: "Total Premium Users",
          quantity: data.totalPremiumUsers.toString(),
        ),
        statCard(
          title: "Monthly Users",
          quantity: data.monthlyActiveUsers.toString(),
        ),
        statCard(
          title: "Daily Users",
          quantity: data.dailyActiveUsers.toString(),
        ),
      ],
    );
  }

  Wrap userStatsCardsWrap(AnalyticsData data) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        statCard(
          title: "Total Users",
          quantity: data.totalUsers.toString(),
        ),
        statCard(
          title: "PETA KARTICA",
          quantity: "0000000",
        ),
        statCard(
          title: "Total Premium Users",
          quantity: data.totalPremiumUsers.toString(),
        ),
        statCard(
          title: "Monthly Users",
          quantity: data.monthlyActiveUsers.toString(),
        ),
        statCard(
          title: "Daily Users",
          quantity: data.dailyActiveUsers.toString(),
        ),
      ],
    );
  }

  Row decksAndCardsStatsCardsRow(AnalyticsData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard(
          title: "Total Decks Created",
          quantity: data.totalDecksCreated.toString(),
        ),
        statCard(
          title: "Total Cards Created",
          quantity: data.totalCardsCreated.toString(),
        ),
        statCard(
          title: "Decks per User",
          quantity: data.deckPerUser.toString(),
        ),
        statCard(
          title: "Average Deck Size",
          quantity: data.averageDeckSize.toString(),
        ),
        statCard(
          title: "Average Ease Factor",
          quantity: data.averageEaseFactor.toString(),
        ),
      ],
    );
  }

  Wrap decksAndCardsStatsCardsWrap(AnalyticsData data) {
    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: [
        statCard(
          title: "Total Decks Created",
          quantity: data.totalDecksCreated.toString(),
        ),
        statCard(
          title: "Total Cards Created",
          quantity: data.totalCardsCreated.toString(),
        ),
        statCard(
          title: "Decks per User",
          quantity: data.deckPerUser.toString(),
        ),
        statCard(
          title: "Average Deck Size",
          quantity: data.averageDeckSize.toString(),
        ),
        statCard(
          title: "Average Ease Factor",
          quantity: data.averageEaseFactor.toString(),
        ),
      ],
    );
  }

  Row studySessionStatsRow(AnalyticsData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard(
          title: "Study Sessions Completed",
          quantity: data.totalStudySessions.toString(),
        ),
        statCard(
          title: "Time Spent Studying",
          quantity: formatTime(data.totalTimeSpentStudying, true),
        ),
        statCard(
          title: "Average Session Duration",
          quantity: formatTime(data.averageSessionDuration, true),
        ),
        statCard(
          title: "Average Study Streak",
          quantity: data.averageStudyStreak.toString(),
        ),
        statCard(
          title: "Longest Study Streak",
          quantity: data.longestStudyStreak.toString(),
        ),
      ],
    );
  }

  Wrap studySessionStatsWrap(AnalyticsData data) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        statCard(
          title: "Study Sessions Completed",
          quantity: data.totalStudySessions.toString(),
        ),
        statCard(
          title: "Time Spent Studying",
          quantity: formatTime(data.totalTimeSpentStudying, true),
        ),
        statCard(
          title: "Average Session Duration",
          quantity: formatTime(data.averageSessionDuration, true),
        ),
        statCard(
          title: "Average Study Streak",
          quantity: data.averageStudyStreak.toString(),
        ),
        statCard(
          title: "Longest Study Streak",
          quantity: data.longestStudyStreak.toString(),
        ),
      ],
    );
  }

  onYearChanged(int year) {
    setState(() {
      _analyticsFuture = AnalyticsService().getAnalyticsData(year);
    });
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

  String formatTime(num seconds, bool short) {
    if (seconds < 3600 && !short) {
      num minutes = (seconds ~/ 60);
      num remainingSeconds = (seconds % 60).toInt();
      return "$minutes:${remainingSeconds.toString().padLeft(2, '0')} minutes";
    } else if (seconds < 3600 && short) {
      num minutes = (seconds ~/ 60);
      num remainingSeconds = (seconds % 60).toInt();
      return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}m";
    } else if (seconds > 3600 && short) {
      num hours = (seconds ~/ 3600);
      num remainingMinutes = ((seconds % 3600) ~/ 60).toInt();
      return "$hours:${remainingMinutes.toString().padLeft(2, '0')}h";
    } else {
      num hours = (seconds ~/ 3600);
      num remainingMinutes = ((seconds % 3600) ~/ 60).toInt();
      return "$hours:${remainingMinutes.toString().padLeft(2, '0')} hours";
    }
  }
}
