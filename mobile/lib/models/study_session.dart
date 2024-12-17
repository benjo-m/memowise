class StudySession {
  int userId;
  int duration;
  int cardCount;
  num averageEaseFactor;
  num averageRepetitions;
  DateTime studiedAt;

  StudySession({
    required this.userId,
    required this.duration,
    required this.cardCount,
    required this.averageEaseFactor,
    required this.averageRepetitions,
    required this.studiedAt,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        userId: json["userId"],
        duration: json["duration"],
        cardCount: json["cardCount"],
        averageEaseFactor: json["averageEaseFactor"]?.toDouble(),
        averageRepetitions: json["averageRepetitions"]?.toDouble(),
        studiedAt: DateTime.parse(json["studiedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "duration": duration,
        "cardCount": cardCount,
        "averageEaseFactor": averageEaseFactor,
        "averageRepetitions": averageRepetitions,
        "studiedAt": studiedAt.toIso8601String(),
      };
}
