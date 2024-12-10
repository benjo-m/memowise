class CardStatsUpdateRequest {
  int cardId;
  num easeFactor;
  int interval;
  int repetitions;

  CardStatsUpdateRequest({
    required this.cardId,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardId': cardId,
      'easeFactor': easeFactor,
      'interval': interval,
      'repetitions': repetitions,
    };
  }
}
