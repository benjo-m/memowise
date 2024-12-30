import 'package:desktop/dto/dashboard_data.dart';
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
    return AspectRatio(
      aspectRatio: 0.86,
      child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: 90,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 5,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              indicator(Colors.greenAccent, "Free"),
              indicator(Colors.blueAccent, "Premium"),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double radius = 70;

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
