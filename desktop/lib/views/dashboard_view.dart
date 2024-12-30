import 'package:desktop/dto/dashboard_data.dart';
import 'package:desktop/services/analytics_service.dart';
import 'package:desktop/widgets/user_distribution_chart.dart';
import 'package:desktop/widgets/user_growth_chart.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final Future<DashboardData> _dashboardDataFuture =
      AnalyticsService().getDashboardData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FutureBuilder(
          future: _dashboardDataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statCard(
                          title: "New Users",
                          quantity: 12245,
                          bottomText: "12% up vs last month",
                        ),
                        statCard(
                          title: "New Users",
                          quantity: 12245,
                          bottomText: "12% up vs last month",
                        ),
                        statCard(
                          title: "New Users",
                          quantity: 12245,
                          bottomText: "12% up vs last month",
                        ),
                        statCard(
                          title: "New Users",
                          quantity: 12245,
                          bottomText: "12% up vs last month",
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    MediaQuery.sizeOf(context).width > 1200
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                  flex: 3,
                                  child: userGrowthChart(data.userGrowth)),
                              const SizedBox(width: 50),
                              Flexible(
                                  child: userDistributionChart(
                                      data.userDistribution)),
                            ],
                          )
                        : Wrap(
                            runSpacing: 50,
                            children: [
                              userGrowthChart(data.userGrowth),
                              userDistributionChart(data.userDistribution),
                            ],
                          )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Flexible statCard(
      {required String title,
      required int quantity,
      required String bottomText}) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Text(title),
            Text(quantity.toString()),
            Text(bottomText),
          ],
        ),
      ),
    );
  }

  Container userGrowthChart(UserGrowth userGrowth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromARGB(255, 195, 236, 255),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent User Growth",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          UserGrowthChart(
            userGrowth: userGrowth,
          ),
        ],
      ),
    );
  }

  Container userDistributionChart(UserDistribution userDistribution) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromARGB(255, 195, 236, 255),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "User Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          UserDistributionChart(userDistribution: userDistribution),
        ],
      ),
    );
  }
}
