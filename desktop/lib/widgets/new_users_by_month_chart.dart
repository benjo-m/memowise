import 'dart:math';

import 'package:desktop/dto/analytics_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NewUsersByMonthChart extends StatelessWidget {
  const NewUsersByMonthChart({
    super.key,
    required this.newUsersData,
  });

  final List<NewUsersByMonth> newUsersData;

  int getMax() {
    if (newUsersData.isEmpty) {
      throw Exception("The list is empty");
    }
    return newUsersData.map((entry) => entry.count).reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: BarChart(
        BarChartData(
          titlesData: titlesData,
          borderData: borderData,
          barTouchData: barTouchData,
          barGroups: barGroups(),
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: getMax().toDouble() + 10,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 94, 94, 94),
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> barGroups() {
    List<BarChartGroupData> data = [];

    for (var i = 0; i < newUsersData.length; i++) {
      final count = newUsersData[i].count;
      data.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: count.isNaN || count.isInfinite ? 0.0 : count.toDouble(),
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }

    return data;
  }
}
