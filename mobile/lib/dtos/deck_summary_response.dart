class DeckSummary {
  int id;
  String name;
  int newCards;
  int learningCards;
  int learnedCards;

  DeckSummary({
    required this.id,
    required this.name,
    required this.newCards,
    required this.learningCards,
    required this.learnedCards,
  });

  factory DeckSummary.fromJson(Map<String, dynamic> json) => DeckSummary(
        id: json["id"],
        name: json["name"],
        newCards: json["newCards"],
        learningCards: json["learningCards"],
        learnedCards: json["learnedCards"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "newCards": newCards,
        "learningCards": learningCards,
        "learnedCards": learnedCards,
      };
}
