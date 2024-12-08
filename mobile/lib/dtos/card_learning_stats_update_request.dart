class CardLearningStatsUpdateRequest {
  final String id;
  final double easeFactor;
  final int interval;
  final int repetitions;

  CardLearningStatsUpdateRequest({
    required this.id,
    required this.easeFactor,
    required this.interval,
    required this.repetitions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'easeFactor': easeFactor,
      'interval': interval,
      'repetitions': repetitions,
    };
  }
}
