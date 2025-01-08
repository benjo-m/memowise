class AchievementDto {
  String name;
  String description;
  String icon;

  AchievementDto({
    required this.name,
    required this.description,
    required this.icon,
  });

  factory AchievementDto.fromJson(Map<String, dynamic> json) => AchievementDto(
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "icon": icon,
      };
}
