class UserStatsResponse {
  int id;
  int userId;
  int totalDecksCreated;
  int totalDecksGenerated;
  int totalCardsCreated;
  int totalCardsLearned;
  int studyStreak;
  int longestStudyStreak;
  int totalSessionsCompleted;
  int totalCorrectAnswers;

  UserStatsResponse({
    required this.id,
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

  factory UserStatsResponse.fromJson(Map<String, dynamic> json) =>
      UserStatsResponse(
        id: json["id"],
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
        "id": id,
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
