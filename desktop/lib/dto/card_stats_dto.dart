class CardStatsDto {
  int repetitions;
  int interval;
  num easeFactor;
  DateTime dueDate;
  int cardId;

  CardStatsDto({
    required this.repetitions,
    required this.interval,
    required this.easeFactor,
    required this.dueDate,
    required this.cardId,
  });

  factory CardStatsDto.fromJson(Map<String, dynamic> json) => CardStatsDto(
        repetitions: json["repetitions"],
        interval: json["interval"],
        easeFactor: json["easeFactor"],
        dueDate: DateTime.parse(json["dueDate"]),
        cardId: json["cardId"],
      );

  Map<String, dynamic> toJson() => {
        "repetitions": repetitions,
        "interval": interval,
        "easeFactor": easeFactor,
        "dueDate": dueDate.toIso8601String(),
        "cardId": cardId,
      };
}
