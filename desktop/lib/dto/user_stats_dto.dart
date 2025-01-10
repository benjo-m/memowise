class UserStatsDto {
  int userId;
  int totalDecksCreated;
  int totalDecksGenerated;
  int totalCardsCreated;
  int totalCardsLearned;
  int studyStreak;
  int longestStudyStreak;
  int totalSessionsCompleted;
  int totalCorrectAnswers;

  UserStatsDto({
    required this.userId,
    required this.totalDecksCreated,
    required this.totalDecksGenerated,
    required this.totalCardsCreated,
    required this.totalCardsLearned,
    required this.studyStreak,
    required this.longestStudyStreak,
    required this.totalSessionsCompleted,
    required this.totalCorrectAnswers,
  });

  factory UserStatsDto.fromJson(Map<String, dynamic> json) => UserStatsDto(
        userId: json["userId"],
        totalDecksCreated: json["totalDecksCreated"],
        totalDecksGenerated: json["totalDecksGenerated"],
        totalCardsCreated: json["totalCardsCreated"],
        totalCardsLearned: json["totalCardsLearned"],
        studyStreak: json["studyStreak"],
        longestStudyStreak: json["longestStudyStreak"],
        totalSessionsCompleted: json["totalSessionsCompleted"],
        totalCorrectAnswers: json["totalCorrectAnswers"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "totalDecksCreated": totalDecksCreated,
        "totalDecksGenerated": totalDecksGenerated,
        "totalCardsCreated": totalCardsCreated,
        "totalCardsLearned": totalCardsLearned,
        "studyStreak": studyStreak,
        "longestStudyStreak": longestStudyStreak,
        "totalSessionsCompleted": totalSessionsCompleted,
        "totalCorrectAnswers": totalCorrectAnswers,
      };
}
