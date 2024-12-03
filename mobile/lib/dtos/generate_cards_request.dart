class GenerateCardsRequest {
  String topic;
  int cardCount;

  GenerateCardsRequest({
    required this.topic,
    required this.cardCount,
  });

  factory GenerateCardsRequest.fromJson(Map<String, dynamic> json) =>
      GenerateCardsRequest(
        topic: json["topic"],
        cardCount: json["cardCount"],
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "cardCount": cardCount,
      };
}
