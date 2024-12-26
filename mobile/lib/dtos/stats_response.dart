class StatsResponse {
  int totalDecksCreated;
  int totalDecksCreatedManually;
  int totalDecksGenerated;
  List<MostStudiedDeck> mostStudiedDecks;
  num averageDeckSize;
  int totalCardsCreated;
  int totalCardsLearned;
  int totalCardsRated1;
  int totalCardsRated2;
  int totalCardsRated3;
  int totalCardsRated4;
  int totalCardsRated5;
  int timeSpentStudying;
  int currentStudyStreak;
  int longestStudyStreak;
  int longestStudySession;
  num averageStudySessionDuration;

  StatsResponse({
    required this.totalDecksCreated,
    required this.totalDecksCreatedManually,
    required this.totalDecksGenerated,
    required this.mostStudiedDecks,
    required this.averageDeckSize,
    required this.totalCardsCreated,
    required this.totalCardsLearned,
    required this.totalCardsRated1,
    required this.totalCardsRated2,
    required this.totalCardsRated3,
    required this.totalCardsRated4,
    required this.totalCardsRated5,
    required this.timeSpentStudying,
    required this.currentStudyStreak,
    required this.longestStudyStreak,
    required this.longestStudySession,
    required this.averageStudySessionDuration,
  });

  factory StatsResponse.fromJson(Map<String, dynamic> json) => StatsResponse(
        totalDecksCreated: json["totalDecksCreated"],
        totalDecksCreatedManually: json["totalDecksCreatedManually"],
        totalDecksGenerated: json["totalDecksGenerated"],
        mostStudiedDecks: List<MostStudiedDeck>.from(
            json["mostStudiedDecks"].map((x) => MostStudiedDeck.fromJson(x))),
        averageDeckSize: json["averageDeckSize"],
        totalCardsCreated: json["totalCardsCreated"],
        totalCardsLearned: json["totalCardsLearned"],
        totalCardsRated1: json["totalCardsRated1"],
        totalCardsRated2: json["totalCardsRated2"],
        totalCardsRated3: json["totalCardsRated3"],
        totalCardsRated4: json["totalCardsRated4"],
        totalCardsRated5: json["totalCardsRated5"],
        timeSpentStudying: json["timeSpentStudying"],
        currentStudyStreak: json["currentStudyStreak"],
        longestStudyStreak: json["longestStudyStreak"],
        longestStudySession: json["longestStudySession"],
        averageStudySessionDuration: json["averageStudySessionDuration"],
      );

  Map<String, dynamic> toJson() => {
        "totalDecksCreated": totalDecksCreated,
        "totalDecksCreatedManually": totalDecksCreatedManually,
        "totalDecksGenerated": totalDecksGenerated,
        "mostStudiedDecks":
            List<dynamic>.from(mostStudiedDecks.map((x) => x.toJson())),
        "averageDeckSize": averageDeckSize,
        "totalCardsCreated": totalCardsCreated,
        "totalCardsLearned": totalCardsLearned,
        "totalCardsRated1": totalCardsRated1,
        "totalCardsRated2": totalCardsRated2,
        "totalCardsRated3": totalCardsRated3,
        "totalCardsRated4": totalCardsRated4,
        "totalCardsRated5": totalCardsRated5,
        "timeSpentStudying": timeSpentStudying,
        "currentStudyStreak": currentStudyStreak,
        "longestStudyStreak": longestStudyStreak,
        "longestStudySession": longestStudySession,
        "averageStudySessionDuration": averageStudySessionDuration,
      };
}

class MostStudiedDeck {
  String deckName;
  int timesStudied;

  MostStudiedDeck({
    required this.deckName,
    required this.timesStudied,
  });

  factory MostStudiedDeck.fromJson(Map<String, dynamic> json) =>
      MostStudiedDeck(
        deckName: json["deckName"],
        timesStudied: json["timesStudied"],
      );

  Map<String, dynamic> toJson() => {
        "deckName": deckName,
        "timesStudied": timesStudied,
      };
}
