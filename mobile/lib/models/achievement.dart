class Achievement {
  int id;
  String name;
  String description;
  String icon;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
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
