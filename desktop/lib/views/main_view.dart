import 'package:desktop/views/analytics_view.dart';
import 'package:desktop/views/dashboard_view.dart';
import 'package:desktop/views/data_view.dart';
import 'package:desktop/views/feedback_view.dart';
import 'package:desktop/views/reporting_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardView(),
    AnalyticsView(),
    DataView(),
    ReportingView(),
    FeedbackView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation Bar
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
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
                icon: Icon(FontAwesomeIcons.solidFileLines),
                label: Text('Reporting'),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.thumbs_up_down_rounded),
                label: Text('Feedback'),
              ),
            ],
          ),
          // Main Content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
