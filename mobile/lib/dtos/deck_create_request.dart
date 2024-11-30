import 'package:mobile/dtos/card_dto.dart';

class DeckCreateRequest {
  String name;
  List<CardDto> cards;

  DeckCreateRequest({
    required this.name,
    required this.cards,
  });

  factory DeckCreateRequest.fromJson(Map<String, dynamic> json) =>
      DeckCreateRequest(
        name: json["name"],
        cards:
            List<CardDto>.from(json["cards"].map((x) => CardDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}
