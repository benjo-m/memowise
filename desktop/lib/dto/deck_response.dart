class DeckResponse {
  int id;
  String name;
  int userId;

  DeckResponse({
    required this.id,
    required this.name,
    required this.userId,
  });

  factory DeckResponse.fromJson(Map<String, dynamic> json) => DeckResponse(
        id: json["id"],
        name: json["name"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userId": userId,
      };
}
