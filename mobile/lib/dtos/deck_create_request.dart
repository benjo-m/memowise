class DeckCreateRequest {
  String name;
  List<CardCreateRequest> cards;

  DeckCreateRequest({
    required this.name,
    required this.cards,
  });

  factory DeckCreateRequest.fromJson(Map<String, dynamic> json) =>
      DeckCreateRequest(
        name: json["name"],
        cards: List<CardCreateRequest>.from(
            json["cards"].map((x) => CardCreateRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}

class CardCreateRequest {
  String question;
  String answer;

  CardCreateRequest({
    required this.question,
    required this.answer,
  });

  factory CardCreateRequest.fromJson(Map<String, dynamic> json) =>
      CardCreateRequest(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}
