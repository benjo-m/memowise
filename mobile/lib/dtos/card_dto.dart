class CardDto {
  String question;
  String answer;

  CardDto({
    required this.question,
    required this.answer,
  });

  factory CardDto.fromJson(Map<String, dynamic> json) => CardDto(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}
