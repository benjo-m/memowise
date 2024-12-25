class StudySession {
  int userId;
  int deckId;
  int duration;
  int cardCount;
  num averageEaseFactor;
  num averageRepetitions;
  DateTime studiedAt;
  int cardsRated1;
  int cardsRated2;
  int cardsRated3;
  int cardsRated4;
  int cardsRated5;

  StudySession({
    required this.userId,
    required this.deckId,
    required this.duration,
    required this.cardCount,
    required this.averageEaseFactor,
    required this.averageRepetitions,
    required this.studiedAt,
    required this.cardsRated1,
    required this.cardsRated2,
    required this.cardsRated3,
    required this.cardsRated4,
    required this.cardsRated5,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        userId: json["userId"],
        deckId: json["deckId"],
        duration: json["duration"],
        cardCount: json["cardCount"],
        averageEaseFactor: json["averageEaseFactor"]?.toDouble(),
        averageRepetitions: json["averageRepetitions"]?.toDouble(),
        studiedAt: DateTime.parse(json["studiedAt"]),
        cardsRated1: json["cardsRated1"],
        cardsRated2: json["cardsRated2"],
        cardsRated3: json["cardsRated3"],
        cardsRated4: json["cardsRated4"],
        cardsRated5: json["cardsRated5"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deckId": deckId,
        "duration": duration,
        "cardCount": cardCount,
        "averageEaseFactor": averageEaseFactor,
        "averageRepetitions": averageRepetitions,
        "studiedAt": studiedAt.toIso8601String(),
        "cardsRated1": cardsRated1,
        "cardsRated2": cardsRated2,
        "cardsRated3": cardsRated3,
        "cardsRated4": cardsRated4,
        "cardsRated5": cardsRated5,
      };
}
