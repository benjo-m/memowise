class CardDto {
  String question;
  String answer;
  int deckId;

  CardDto({
    required this.question,
    required this.answer,
    required this.deckId,
  });

  factory CardDto.fromJson(Map<String, dynamic> json) => CardDto(
        question: json["question"],
        answer: json["answer"],
        deckId: json["deckId"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "deckId": deckId,
      };
}
