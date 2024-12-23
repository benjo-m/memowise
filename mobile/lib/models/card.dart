import 'package:mobile/dtos/card_dto.dart';
import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/card_stats.dart';

class Card {
  int id;
  String question;
  String answer;
  String? questionImage;
  String? answerImage;
  CardStats cardStats;

  Card({
    required this.id,
    required this.question,
    required this.answer,
    required this.questionImage,
    required this.answerImage,
    required this.cardStats,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        questionImage: json["questionImage"],
        answerImage: json["answerImage"],
        cardStats: CardStats.fromJson(json["cardStats"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "questionImage": questionImage,
        "answerImage": answerImage,
        "cardStats": cardStats,
      };

  void updateCardStats(CardStatsUpdateRequest cardStatsUpdateRequest) {
    cardStats.easeFactor = cardStatsUpdateRequest.easeFactor;
    cardStats.repetitions = cardStatsUpdateRequest.repetitions;
    cardStats.interval = cardStatsUpdateRequest.interval;
  }

  void editCard(CardDto cardDto) {
    question = cardDto.question;
    answer = cardDto.answer;
    questionImage = cardDto.questionImage;
    answerImage = cardDto.answerImage;
  }
}
