import 'package:mobile/dtos/card_dto.dart';

class GenerateCardsResponse {
  List<CardDto> cards;

  GenerateCardsResponse({
    required this.cards,
  });

  factory GenerateCardsResponse.fromJson(Map<String, dynamic> json) =>
      GenerateCardsResponse(
        cards:
            List<CardDto>.from(json["cards"].map((x) => CardDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
      };
}
