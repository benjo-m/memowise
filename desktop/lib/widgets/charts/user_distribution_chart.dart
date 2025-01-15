import 'package:desktop/dto/dashboard_data.dart';
import 'package:desktop/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserDistributionChart extends StatefulWidget {
  const UserDistributionChart({super.key, required this.userDistribution});

  final UserDistribution userDistribution;

  @override
  State<UserDistributionChart> createState() => _UserDistributionChartState();
}

class _UserDistributionChartState extends State<UserDistributionChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
        border: Border.all(
          width: 3,
          color: primaryBorderColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "User Distribution",
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
                indicator(Colors.greenAccent, "Free"),
                indicator(Colors.blueAccent, "Premium"),
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
        title: '${widget.userDistribution.freeUsersPercentage}%',
        value: widget.userDistribution.freeUsersPercentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.greenAccent,
        radius: radius,
      ),
      PieChartSectionData(
        title: "${widget.userDistribution.premiumUsersPercentage}%",
        value: widget.userDistribution.premiumUsersPercentage.toDouble(),
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.blueAccent,
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
