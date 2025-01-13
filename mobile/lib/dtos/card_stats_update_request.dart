class CardStatsUpdateRequest {
  int cardId;
  num easeFactor;
  int interval;
  int repetitions;
  DateTime dueDate;

  CardStatsUpdateRequest({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
    required this.dueDate,
  });

  factory CardStatsUpdateRequest.fromJson(Map<String, dynamic> json) =>
      CardStatsUpdateRequest(
        cardId: json["cardId"],
        easeFactor: json["easeFactor"],
        interval: json["interval"],
        repetitions: json["repetitions"],
        dueDate: DateTime.parse(json["dueDate"]),
      );

  Map<String, dynamic> toJson() => {
        "cardId": cardId,
        "easeFactor": easeFactor,
        "interval": interval,
        "repetitions": repetitions,
        "dueDate": dueDate.toIso8601String(),
      };
}
