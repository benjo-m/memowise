import 'package:desktop/services/auth_service.dart';
import 'package:desktop/views/analytics_view.dart';
import 'package:desktop/views/dashboard_view.dart';
import 'package:desktop/views/data_view.dart';
import 'package:desktop/views/feedback_view.dart';
import 'package:desktop/widgets/dialogs/logout_dialog.dart';
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
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          child: const Icon(
                            FontAwesomeIcons.rightFromBracket,
                            color: Color.fromARGB(255, 54, 54, 54),
                          ),
                          onPressed: () => showDialog(
                                context: context,
                                builder: (context) => const LogoutDialog(),
                              )),
                      const Text(
                        "Log Out",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Color.fromARGB(255, 226, 246, 255),
            destinations: [
              const NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.dashboard_rounded),
                label: Text('Dashboard'),
              ),
              const NavigationRailDestination(
                padding: EdgeInsets.only(bottom: 20),
                icon: Icon(Icons.bar_chart_rounded),
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                padding: const EdgeInsets.only(bottom: 20),
                icon: const Icon(FontAwesomeIcons.database),
                label: const Text('Data'),
                disabled: !CurrentUser.isSuperAdmin!,
              ),
              const NavigationRailDestination(
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
