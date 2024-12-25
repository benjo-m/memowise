import 'package:mobile/models/achievement.dart';

class UnlockedAchievementsResponse {
  List<Achievement> achievements;
  double progress;

  UnlockedAchievementsResponse({
    required this.achievements,
    required this.progress,
  });

  factory UnlockedAchievementsResponse.fromJson(Map<String, dynamic> json) =>
      UnlockedAchievementsResponse(
        achievements: List<Achievement>.from(
            json["achievements"].map((x) => Achievement.fromJson(x))),
        progress: json["progress"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "achievements": List<dynamic>.from(achievements.map((x) => x.toJson())),
        "progress": progress,
      };
}
