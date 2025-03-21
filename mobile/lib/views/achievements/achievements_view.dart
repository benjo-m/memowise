import 'package:flutter/material.dart';
import 'package:mobile/dtos/unlocked_achievement_response.dart';
import 'package:mobile/models/achievement.dart';
import 'package:mobile/services/achievements_service.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/widgets/achievement_list_item.dart';

class AchievementsView extends StatefulWidget {
  const AchievementsView({super.key});

  @override
  State<AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<AchievementsView> {
  late Future<List<Achievement>> _achievementsFuture;
  int progress = 0;
  UnlockedAchievementsResponse _unlockedAchievements =
      UnlockedAchievementsResponse(achievements: [], progress: 0);

  @override
  void initState() {
    super.initState();
    _getUnlockedAchievements();
    _achievementsFuture = AchievementsService().getAllAchievements();
  }

  Future _getUnlockedAchievements() async {
    final achievements = await AchievementsService()
        .getUnlockedAchievements(CurrentUser.userId!);

    if (mounted) {
      setState(() {
        _unlockedAchievements = achievements;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Unlocked achievements: ${_unlockedAchievements.achievements.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 65, 65, 65),
              ),
            ),
            Text(
              "Progress: ${_unlockedAchievements.progress}%",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 65, 65, 65),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _achievementsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final achievements = snapshot.data!;
                  return Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView(
                        children: achievementsList(achievements),
                      ),
                    ),
                  );
                }

                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              },
            )
          ],
        ),
      ),
    );
  }

  List<AchievementListItem> achievementsList(List<Achievement> achievements) {
    List<AchievementListItem> achievementsList = List.empty(growable: true);

    for (var achievement in achievements) {
      bool isLocked = !_unlockedAchievements.achievements.any(
          (unlockedAchievement) => unlockedAchievement.id == achievement.id);
      achievementsList.add(AchievementListItem(
        achievement: achievement,
        isLocked: isLocked,
      ));
    }

    return achievementsList;
  }
}
