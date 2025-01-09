class DeckDto {
  String name;
  int userId;

  DeckDto({
    required this.name,
    required this.userId,
  });

  factory DeckDto.fromJson(Map<String, dynamic> json) => DeckDto(
        name: json["name"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "userId": userId,
      };
}
