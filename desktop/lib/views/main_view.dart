import 'package:desktop/views/analytics_view.dart';
import 'package:desktop/views/dashboard_view.dart';
import 'package:desktop/views/data_view.dart';
import 'package:desktop/views/feedback/feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const AnalyticsView(),
    const DataView(),
    const FeedbackView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color.fromARGB(255, 240, 240, 240),
            destinations: const [
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.dashboard_rounded),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.bar_chart_rounded),
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(FontAwesomeIcons.database),
                label: Text('Data'),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.thumbs_up_down_rounded),
                label: Text('Feedback'),
              ),
            ],
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
