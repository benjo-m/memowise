class CardStatsResponse {
  int id;
  int repetitions;
  int interval;
  num easeFactor;
  DateTime dueDate;
  int cardId;

  CardStatsResponse({
    required this.id,
    required this.repetitions,
    required this.interval,
    required this.easeFactor,
    required this.dueDate,
    required this.cardId,
  });

  factory CardStatsResponse.fromJson(Map<String, dynamic> json) =>
      CardStatsResponse(
        id: json["id"],
        repetitions: json["repetitions"],
        interval: json["interval"],
        easeFactor: json["easeFactor"],
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
