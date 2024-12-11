class StudySession {
  String firebaseUserUid;
  int duration;
  int cardCount;
  num averageEaseFactor;
  num averageRepetitions;
  DateTime studiedAt;

  StudySession({
    required this.firebaseUserUid,
    required this.duration,
    required this.cardCount,
    required this.averageEaseFactor,
    required this.averageRepetitions,
    required this.studiedAt,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) => StudySession(
        firebaseUserUid: json["firebaseUserUid"],
        duration: json["duration"],
        cardCount: json["cardCount"],
        averageEaseFactor: json["averageEaseFactor"]?.toDouble(),
        averageRepetitions: json["averageRepetitions"]?.toDouble(),
        studiedAt: DateTime.parse(json["studiedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "firebaseUserUid": firebaseUserUid,
        "duration": duration,
        "cardCount": cardCount,
        "averageEaseFactor": averageEaseFactor,
        "averageRepetitions": averageRepetitions,
        "studiedAt": studiedAt.toIso8601String(),
      };
}
