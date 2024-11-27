class DeckCreateRequest {
  String name;

  DeckCreateRequest({
    required this.name,
  });

  factory DeckCreateRequest.fromJson(Map<String, dynamic> json) =>
      DeckCreateRequest(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
