import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/card_stats.dart';

class Card {
  int id;
  String question;
  String answer;
  CardStats cardStats;

  Card({
    required this.id,
    required this.question,
    required this.answer,
    required this.cardStats,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        cardStats:
            CardStats.fromJson(json["cardStats"]), // Correctly parse cardStats
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "cardStats": cardStats,
      };

  void updateCardStats(CardStatsUpdateRequest cardStatsUpdateRequest) {
    cardStats.easeFactor = cardStatsUpdateRequest.easeFactor;
    cardStats.repetitions = cardStatsUpdateRequest.repetitions;
    cardStats.interval = cardStatsUpdateRequest.interval;
  }
}
