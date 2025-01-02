class AchievementResponse {
  int id;
  String name;
  String description;
  String icon;

  AchievementResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory AchievementResponse.fromJson(Map<String, dynamic> json) =>
      AchievementResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
      };
}
