import 'dart:io';

import 'package:desktop/dto/analytics_data.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class ReportService {
  static Future<File> generateReport(AnalyticsData data) {
    final pdf = Document();

    const baseColor = PdfColors.cyan;

    final table = TableHelper.fromTextArray(
      border: TableBorder.all(),
      headers: [
        "Total Users",
        "Premium Users",
        "Monthly Users",
        "Daily Users",
        "Admins"
      ],
      data: [
        [
          data.totalUsers,
          data.totalPremiumUsers,
          data.monthlyActiveUsers,
          data.dailyActiveUsers,
          data.adminCount
        ]
      ],
      headerStyle: TextStyle(
        color: PdfColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.blue300,
      ),
      rowDecoration: const BoxDecoration(),
      cellAlignment: Alignment.center,
      cellAlignments: {0: Alignment.center},
    );

    final userDistributionChart = Chart(
      grid: PieGrid(),
      datasets: <Dataset>[
        PieDataSet(
          legend: "Free\n${data.userDistribution.freeUsersPercentage}%",
          value: data.userDistribution.freeUsersPercentage,
          color: PdfColors.green200,
          legendStyle: const TextStyle(fontSize: 10),
        ),
        PieDataSet(
          legend: "Premium\n${data.userDistribution.premiumUsersPercentage}%",
          value: data.userDistribution.premiumUsersPercentage,
          color: PdfColors.blue300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
      ],
    );

    final newUsersByMonthChart = Chart(
      overlay: ChartLegend(
        position: const Alignment(-.7, 1),
        decoration: BoxDecoration(
          color: PdfColors.white,
          border: Border.all(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      grid: CartesianGrid(
        xAxis: FixedAxis.fromStrings(
          List<String>.generate(data.newUsersByMonth.length,
              (index) => data.newUsersByMonth[index].month.substring(0, 3)),
          marginStart: 20,
          marginEnd: 20,
          ticks: true,
        ),
        yAxis: FixedAxis(
          [0, 25, 50, 75, 100],
          divisions: true,
        ),
      ),
      datasets: [
        BarDataSet(
          color: PdfColors.blue100,
          legend: "New Users",
          width: 15,
          borderColor: baseColor,
          data: List<PointChartValue>.generate(
            data.newUsersByMonth.length,
            (i) {
              final v = data.newUsersByMonth[i].count as num;
              return PointChartValue(i.toDouble(), v.toDouble());
            },
          ),
        ),
      ],
    );

    final table2 = TableHelper.fromTextArray(
      border: TableBorder.all(),
      headers: [
        "Decks Created",
        "Cards Created",
        "Decks per User",
        "Average Deck Size",
        "Average Card Ease Factor",
      ],
      data: [
        [
          data.totalDecksCreated,
          data.totalCardsCreated,
          data.deckPerUser,
          data.averageDeckSize,
          data.averageEaseFactor,
        ]
      ],
      headerStyle: TextStyle(
        color: PdfColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.blue300,
      ),
      rowDecoration: const BoxDecoration(),
      cellAlignment: Alignment.center,
      cellAlignments: {0: Alignment.center},
    );

    final table3 = TableHelper.fromTextArray(
      border: TableBorder.all(),
      headers: [
        "Total Sessions",
        "Time Studied",
        "Avg Session Duration",
        "Avg Streak",
        "Longest Streak",
      ],
      data: [
        [
          data.totalStudySessions,
          formatTime(data.totalTimeSpentStudying),
          formatTime(data.averageSessionDuration),
          data.averageStudyStreak,
          data.longestStudyStreak,
        ]
      ],
      headerStyle: TextStyle(
        color: PdfColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.blue300,
      ),
      rowDecoration: const BoxDecoration(),
      cellAlignment: Alignment.center,
      cellAlignments: {0: Alignment.center},
    );

    final deckCreationChart = Chart(
      grid: PieGrid(),
      datasets: <Dataset>[
        PieDataSet(
          legend: "Manually\n${data.manuallyCreatedDecksPercentage}%",
          value: data.manuallyCreatedDecksPercentage,
          color: PdfColors.green200,
          legendStyle: const TextStyle(fontSize: 10),
        ),
        PieDataSet(
          legend: "Generated\n${data.generatedDecksPercentage}%",
          value: data.generatedDecksPercentage,
          color: PdfColors.blue300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
      ],
    );

    final studyTimesChart = Chart(
      grid: PieGrid(),
      datasets: <Dataset>[
        PieDataSet(
          legend: "Night\n${data.studySessionSegments[0].percentage}%",
          value: data.studySessionSegments[0].percentage,
          color: PdfColors.purple300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
        PieDataSet(
          legend: "Morning\n${data.studySessionSegments[1].percentage}%",
          value: data.studySessionSegments[1].percentage,
          color: PdfColors.green300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
        PieDataSet(
          legend: "Evening\n${data.studySessionSegments[2].percentage}%",
          value: data.studySessionSegments[2].percentage,
          color: PdfColors.blue300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
        PieDataSet(
          legend: "Afternoon\n${data.studySessionSegments[3].percentage}%",
          value: data.studySessionSegments[3].percentage,
          color: PdfColors.orange300,
          legendStyle: const TextStyle(fontSize: 10),
        ),
      ],
    );

    pdf.addPage(
      Page(
        build: (context) => Column(
          children: [
            Text("MemoWise Analytics Report",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Divider(),
            SizedBox(height: 30),
            table,
            SizedBox(height: 35),
            Text(
              "User Distribution",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(width: 230, child: userDistributionChart),
            SizedBox(height: 50),
            Text(
              'New Users per Month for ${data.newUsersByMonth[0].month.substring(data.newUsersByMonth[0].month.length - 4)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(flex: 2, child: newUsersByMonthChart),
          ],
        ),
      ),
    );

    pdf.addPage(
      Page(
        build: (context) => Column(
          children: [
            table3,
            SizedBox(height: 35),
            Text(
              "Study Times",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(width: 230, child: studyTimesChart),
            SizedBox(height: 50),
            table2,
            SizedBox(height: 35),
            Text(
              "Deck Creation Breakdown",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(width: 230, child: deckCreationChart)
          ],
        ),
      ),
    );

    pdf.addPage(
      Page(
        build: (context) => Column(
          children: [
            Text(
              "Achievements",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ...data.achievementUnlockPercentages.map(
              (achievement) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(achievement.name),
                    ),
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 200,
                    child: Stack(children: [
                      Positioned.fill(
                        child: LinearProgressIndicator(
                          value: achievement.percentage / 100,
                        ),
                      ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "${achievement.percentage}%",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return saveDocument(name: 'memowise_report.pdf', pdf: pdf);
  }

  static String formatTime(num seconds) {
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

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
