class DeckUpdateRequest {
  String name;

  DeckUpdateRequest({
    required this.name,
  });

  factory DeckUpdateRequest.fromJson(Map<String, dynamic> json) =>
      DeckUpdateRequest(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
