import 'package:flutter/material.dart';
import 'package:mobile/views/achievements_page/achievements_view.dart';
import 'package:mobile/views/decks_page/decks_view.dart';
import 'package:mobile/views/settings_page/settings_view.dart';
import 'package:mobile/views/stats_page/stats_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentPageIndex = 0;
  final List<Widget> _screens = [
    const DecksView(),
    const StatsView(),
    const AchievementsView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.view_agenda),
            label: 'Decks',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars),
            label: 'Achievements',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _screens[currentPageIndex],
    );
  }
}
