class CardResponse {
  int id;
  String question;
  String answer;
  int deckId;

  CardResponse({
    required this.id,
    required this.question,
    required this.answer,
    required this.deckId,
  });

  factory CardResponse.fromJson(Map<String, dynamic> json) => CardResponse(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        deckId: json["deckId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "deckId": deckId,
      };
}
