import 'package:desktop/dto/dashboard_data.dart';

class AnalyticsData {
  int totalUsers;
  int totalPremiumUsers;
  int monthlyActiveUsers;
  int dailyActiveUsers;
  List<NewUsersByMonth> newUsersByMonth;
  UserDistribution userDistribution;
  UserGrowth userGrowth;
  int totalDecksCreated;
  int totalCardsCreated;
  num deckPerUser;
  num averageDeckSize;
  num averageEaseFactor;
  num manuallyCreatedDecksPercentage;
  num generatedDecksPercentage;
  int totalStudySessions;
  int totalTimeSpentStudying;
  num averageSessionDuration;
  num averageStudyStreak;
  int longestStudyStreak;
  List<StudySessionSegment> studySessionSegments;
  List<AchievementUnlockPercentage> achievementUnlockPercentages;

  AnalyticsData({
    required this.totalUsers,
    required this.totalPremiumUsers,
    required this.monthlyActiveUsers,
    required this.dailyActiveUsers,
    required this.newUsersByMonth,
    required this.userDistribution,
    required this.userGrowth,
    required this.totalDecksCreated,
    required this.totalCardsCreated,
    required this.deckPerUser,
    required this.averageDeckSize,
    required this.averageEaseFactor,
    required this.manuallyCreatedDecksPercentage,
    required this.generatedDecksPercentage,
    required this.totalStudySessions,
    required this.totalTimeSpentStudying,
    required this.averageSessionDuration,
    required this.averageStudyStreak,
    required this.longestStudyStreak,
    required this.studySessionSegments,
    required this.achievementUnlockPercentages,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) => AnalyticsData(
        totalUsers: json["totalUsers"],
        totalPremiumUsers: json["totalPremiumUsers"],
        monthlyActiveUsers: json["monthlyActiveUsers"],
        dailyActiveUsers: json["dailyActiveUsers"],
        newUsersByMonth: List<NewUsersByMonth>.from(
            json["newUsersByMonth"].map((x) => NewUsersByMonth.fromJson(x))),
        userDistribution: UserDistribution.fromJson(json["userDistribution"]),
        userGrowth: UserGrowth.fromJson(json["userGrowth"]),
        totalDecksCreated: json["totalDecksCreated"],
        totalCardsCreated: json["totalCardsCreated"],
        deckPerUser: json["deckPerUser"],
        averageDeckSize: json["averageDeckSize"],
        averageEaseFactor: json["averageEaseFactor"],
        manuallyCreatedDecksPercentage: json["manuallyCreatedDecksPercentage"],
        generatedDecksPercentage: json["generatedDecksPercentage"],
        totalStudySessions: json["totalStudySessions"],
        totalTimeSpentStudying: json["totalTimeSpentStudying"],
        averageSessionDuration: json["averageSessionDuration"],
        averageStudyStreak: json["averageStudyStreak"],
        longestStudyStreak: json["longestStudyStreak"],
        studySessionSegments: List<StudySessionSegment>.from(
            json["studySessionSegments"]
                .map((x) => StudySessionSegment.fromJson(x))),
        achievementUnlockPercentages: List<AchievementUnlockPercentage>.from(
            json["achievementUnlockPercentages"]
                .map((x) => AchievementUnlockPercentage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalUsers": totalUsers,
        "totalPremiumUsers": totalPremiumUsers,
        "monthlyActiveUsers": monthlyActiveUsers,
        "dailyActiveUsers": dailyActiveUsers,
        "newUsersByMonth":
            List<dynamic>.from(newUsersByMonth.map((x) => x.toJson())),
        "userDistribution": userDistribution.toJson(),
        "userGrowth": userGrowth.toJson(),
        "totalDecksCreated": totalDecksCreated,
        "totalCardsCreated": totalCardsCreated,
        "deckPerUser": deckPerUser,
        "averageDeckSize": averageDeckSize,
        "averageEaseFactor": averageEaseFactor,
        "manuallyCreatedDecksPercentage": manuallyCreatedDecksPercentage,
        "generatedDecksPercentage": generatedDecksPercentage,
        "totalStudySessions": totalStudySessions,
        "totalTimeSpentStudying": totalTimeSpentStudying,
        "averageSessionDuration": averageSessionDuration,
        "averageStudyStreak": averageStudyStreak,
        "longestStudyStreak": longestStudyStreak,
        "studySessionSegments":
            List<dynamic>.from(studySessionSegments.map((x) => x.toJson())),
        "achievementUnlockPercentages": List<dynamic>.from(
            achievementUnlockPercentages.map((x) => x.toJson())),
      };
}

class AchievementUnlockPercentage {
  String name;
  num percentage;

  AchievementUnlockPercentage({
    required this.name,
    required this.percentage,
  });

  factory AchievementUnlockPercentage.fromJson(Map<String, dynamic> json) =>
      AchievementUnlockPercentage(
        name: json["name"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "percentage": percentage,
      };
}

class NewUsersByMonth {
  String month;
  int count;

  NewUsersByMonth({
    required this.month,
    required this.count,
  });

  factory NewUsersByMonth.fromJson(Map<String, dynamic> json) =>
      NewUsersByMonth(
        month: json["month"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "count": count,
      };
}

class StudySessionSegment {
  String segment;
  int count;
  num percentage;

  StudySessionSegment({
    required this.segment,
    required this.count,
    required this.percentage,
  });

  factory StudySessionSegment.fromJson(Map<String, dynamic> json) =>
      StudySessionSegment(
        segment: json["segment"],
        count: json["count"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "segment": segment,
        "count": count,
        "percentage": percentage,
      };
}
