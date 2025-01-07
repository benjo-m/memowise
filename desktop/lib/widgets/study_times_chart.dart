import 'package:desktop/dto/analytics_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudyTimesChart extends StatefulWidget {
  const StudyTimesChart({
    super.key,
    required this.studySessionSegments,
  });

  final List<StudySessionSegment> studySessionSegments;

  @override
  State<StudyTimesChart> createState() => _StudyTimesChartState();
}

class _StudyTimesChartState extends State<StudyTimesChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Study Times",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              constraints: const BoxConstraints(
                minHeight: 300,
              ),
              child: PieChart(
                PieChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 5,
                  centerSpaceRadius: 70,
                  sections: showingSections(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                indicator(Colors.greenAccent, "Morning"),
                indicator(Colors.orangeAccent, "Afternoon"),
                indicator(Colors.blueAccent, "Evening"),
                indicator(Colors.deepPurpleAccent, "Night"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double radius = 50;

    return <PieChartSectionData>[
      PieChartSectionData(
        title: '${widget.studySessionSegments[0].percentage}%',
        value: widget.studySessionSegments[0].percentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.deepPurpleAccent,
        radius: radius,
      ),
      PieChartSectionData(
        title: "${widget.studySessionSegments[1].percentage}%",
        value: widget.studySessionSegments[1].percentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.greenAccent,
        radius: radius,
      ),
      PieChartSectionData(
        title: "${widget.studySessionSegments[2].percentage}%",
        value: widget.studySessionSegments[2].percentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.blueAccent,
        radius: radius,
      ),
      PieChartSectionData(
        title: "${widget.studySessionSegments[3].percentage}%",
        value: widget.studySessionSegments[3].percentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.orangeAccent,
        radius: radius,
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
}
