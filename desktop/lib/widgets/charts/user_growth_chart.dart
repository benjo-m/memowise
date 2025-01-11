import 'package:desktop/dto/dashboard_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserGrowthChart extends StatefulWidget {
  const UserGrowthChart({super.key, required this.userGrowth});

  final UserGrowth userGrowth;

  @override
  State<UserGrowthChart> createState() => _UserGrowthChartState();
}

class _UserGrowthChartState extends State<UserGrowthChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "User Growth",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 500, // Enforce minimum width here
                minHeight: 300, // Enforce minimum height here
              ),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
            const Text(""),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =
            Text(getMonthName(widget.userGrowth.data[0].month), style: style);
        break;
      case 3:
        text =
            Text(getMonthName(widget.userGrowth.data[1].month), style: style);
        break;
      case 6:
        text =
            Text(getMonthName(widget.userGrowth.data[2].month), style: style);
        break;
      case 9:
        text =
            Text(getMonthName(widget.userGrowth.data[3].month), style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    final int maxCount = getLargestCount(widget.userGrowth);
    String text;

    if (value == 0) {
      text = '0 users';
    } else if (value == maxCount.toDouble() + 20) {
      text = '${(maxCount + 20).toInt().toString()} users';
    } else if (value == (maxCount + 20) ~/ 2.toDouble()) {
      text = '${((maxCount + 20) ~/ 2).toString()} users';
    } else {
      return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.lightGreen,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.lightBlueAccent,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 90,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 9,
      minY: 0,
      maxY: getLargestCount(widget.userGrowth).toDouble() + 20,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, widget.userGrowth.data[0].count.toDouble()),
            FlSpot(3, widget.userGrowth.data[1].count.toDouble()),
            FlSpot(6, widget.userGrowth.data[2].count.toDouble()),
            FlSpot(9, widget.userGrowth.data[3].count.toDouble()),
          ],

          // isCurved: true,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }

  String getMonthName(int monthNumber) {
    const monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    return monthNames[monthNumber - 1];
  }

  int getLargestCount(UserGrowth userGrowth) {
    if (userGrowth.data.isEmpty) {
      throw ArgumentError('Data list cannot be empty.');
    }

    return userGrowth.data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
  }
}
