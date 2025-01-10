class UserDto {
  String username;
  String email;
  bool isPremium;
  bool isAdmin;
  DateTime createdAt;
  String password;

  UserDto({
    required this.username,
    required this.email,
    required this.isPremium,
    required this.isAdmin,
    required this.createdAt,
    required this.password,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        username: json["username"],
        email: json["email"],
        isPremium: json["isPremium"],
        isAdmin: json["isAdmin"],
        password: json["password"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "isPremium": isPremium,
        "isAdmin": isAdmin,
        "createdAt": createdAt.toIso8601String(),
        "password": password,
      };
}
