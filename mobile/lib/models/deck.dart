import 'package:mobile/models/card.dart';

class Deck {
  int id;
  String name;
  List<Card> cards;

  Deck({
    required this.id,
    required this.name,
    required this.cards,
  });

  factory Deck.fromJson(Map<String, dynamic> json) => Deck(
        id: json["id"],
        name: json["name"],
        cards: List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}
