import 'package:mobile/models/card.dart';

class CardDto {
  String question;
  String answer;
  String? questionImage;
  String? answerImage;

  CardDto({
    required this.question,
    required this.answer,
    required this.questionImage,
    required this.answerImage,
  });

  CardDto.fromCard(Card card)
      : question = card.question,
        answer = card.answer,
        questionImage = card.questionImage,
        answerImage = card.answerImage;

  factory CardDto.fromJson(Map<String, dynamic> json) => CardDto(
        question: json["question"],
        answer: json["answer"],
        questionImage: json["image"],
        answerImage: json["answerImage"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "questionImage": questionImage,
        "answerImage": answerImage,
      };
}
