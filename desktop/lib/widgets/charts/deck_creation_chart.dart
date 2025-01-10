import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DeckCreationChart extends StatefulWidget {
  const DeckCreationChart(
      {super.key,
      required this.percentageCreatedManually,
      required this.percentageGenerated});

  final num percentageCreatedManually;
  final num percentageGenerated;

  @override
  State<DeckCreationChart> createState() => _DeckCreationChartState();
}

class _DeckCreationChartState extends State<DeckCreationChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Deck Creation Method Distribution",
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
                indicator(Colors.greenAccent, "Manually"),
                indicator(Colors.blueAccent, "Generated"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double radius = 50;

    var sections = <PieChartSectionData>[
      PieChartSectionData(
        title: '${widget.percentageCreatedManually}%',
        value: widget.percentageCreatedManually.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.greenAccent,
        radius: radius,
      ),
      PieChartSectionData(
        title: "${widget.percentageGenerated}%",
        value: widget.percentageGenerated.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.blueAccent,
        radius: radius,
      ),
    ];

    var empty = <PieChartSectionData>[
      PieChartSectionData(
        title: '0%',
        value: 100,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.grey,
        radius: radius,
      ),
    ];

    if (widget.percentageCreatedManually == 0 &&
        widget.percentageGenerated == 0) {
      return empty;
    }

    return sections;
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
