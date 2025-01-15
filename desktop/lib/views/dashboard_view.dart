import 'package:desktop/dto/dashboard_data.dart';
import 'package:desktop/services/analytics_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/widgets/charts/user_distribution_chart.dart';
import 'package:desktop/widgets/charts/user_growth_chart.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final fontColor = const Color.fromARGB(255, 58, 58, 58);
  final Future<DashboardData> _dashboardDataFuture =
      AnalyticsService().getDashboardData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Dashboard"),
        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaQuery.sizeOf(context).width > 1400
                        ? statCardsRow(data)
                        : statCardsWrap(data),
                    const SizedBox(height: 50),
                    MediaQuery.sizeOf(context).width > 1150
                        ? chartsRow(data)
                        : chartsWrap(data),
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

  Wrap chartsWrap(DashboardData data) {
    return Wrap(
      spacing: 50,
      runSpacing: 50,
      children: [
        UserGrowthChart(userGrowth: data.userGrowth),
        UserDistributionChart(userDistribution: data.userDistribution),
      ],
    );
  }

  Row chartsRow(DashboardData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: UserGrowthChart(userGrowth: data.userGrowth),
        ),
        const SizedBox(width: 50),
        Flexible(
          flex: 1,
          child: UserDistributionChart(userDistribution: data.userDistribution),
        ),
      ],
    );
  }

  Wrap statCardsWrap(DashboardData data) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        statCard(
            title: "Total Users",
            quantity: data.totalUsers.count,
            bottomText: "+${data.totalUsers.change} last 30 days"),
        statCard(
          title: "New Users",
          quantity: data.newUsers.userCount,
          bottomText: data.newUsers.userCountChange < 0
              ? "${data.newUsers.userCountChange}% down vs last 30 days"
              : "${data.newUsers.userCountChange}% up vs last 30 days",
        ),
        statCard(
          title: "Active Users",
          quantity: data.activeUsers.count,
          bottomText: data.activeUsers.change < 0
              ? "${data.activeUsers.change}% down vs last 30 days"
              : "${data.activeUsers.change}% up vs last 30 days",
        ),
        statCard(
          title: "New Premium Users",
          quantity: data.newUsers.premiumUserCount,
          bottomText: data.newUsers.premiumUserCountChange < 0
              ? "${data.newUsers.premiumUserCountChange}% down vs last 30 days"
              : "${data.newUsers.premiumUserCountChange}% up vs last 30 days",
        ),
        statCard(
          title: "Pending Feedback",
          quantity: data.feedbackCount.pendingFeedback,
          bottomText: "${data.feedbackCount.savedFeedback} saved",
        ),
      ],
    );
  }

  Row statCardsRow(DashboardData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard(
            title: "Total Users",
            quantity: data.totalUsers.count,
            bottomText: "+${data.totalUsers.change} last 30 days"),
        statCard(
          title: "New Users",
          quantity: data.newUsers.userCount,
          bottomText: data.newUsers.userCountChange < 0
              ? "${data.newUsers.userCountChange}% down vs last 30 days"
              : "${data.newUsers.userCountChange}% up vs last 30 days",
        ),
        statCard(
          title: "New Premium Users",
          quantity: data.newUsers.premiumUserCount,
          bottomText: data.newUsers.premiumUserCountChange < 0
              ? "${data.newUsers.premiumUserCountChange}% down vs last 30 days"
              : "${data.newUsers.premiumUserCountChange}% up vs last 30 days",
        ),
        statCard(
          title: "Active Users",
          quantity: data.activeUsers.count,
          bottomText: data.activeUsers.change < 0
              ? "${data.activeUsers.change}% down vs last 30 days"
              : "${data.activeUsers.change}% up vs last 30 days",
        ),
        statCard(
          title: "Pending Feedback",
          quantity: data.feedbackCount.pendingFeedback,
          bottomText: "${data.feedbackCount.savedFeedback} saved",
        ),
      ],
    );
  }

  Container statCard({
    required String title,
    required num quantity,
    required String bottomText,
  }) {
    return Container(
      width: 250,
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(
          width: 3,
          color: primaryBorderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            bottomText,
            style: TextStyle(
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }
}
