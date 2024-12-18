class Achievement {
  int id;
  String name;
  String description;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}
