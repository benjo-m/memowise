class CardStats {
  int id;
  int repetitions;
  int interval;
  num easeFactor;
  DateTime dueDate;
  int cardId;

  CardStats({
    required this.id,
    required this.repetitions,
    required this.interval,
    required this.easeFactor,
    required this.dueDate,
    required this.cardId,
  });

  factory CardStats.fromJson(Map<String, dynamic> json) => CardStats(
        id: json["id"],
        repetitions: json["repetitions"],
        interval: json["interval"],
        easeFactor: json["easeFactor"]?.toDouble(),
        dueDate: DateTime.parse(json["dueDate"]),
        cardId: json["cardId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "repetitions": repetitions,
        "interval": interval,
        "easeFactor": easeFactor,
        "dueDate": dueDate.toIso8601String(),
        "cardId": cardId,
      };
}
