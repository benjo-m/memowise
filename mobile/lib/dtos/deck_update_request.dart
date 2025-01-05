class DeckUpdateRequest {
  String name;
  int userId;

  DeckUpdateRequest({
    required this.name,
    required this.userId,
  });

  factory DeckUpdateRequest.fromJson(Map<String, dynamic> json) =>
      DeckUpdateRequest(
        name: json["name"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
      };
}
