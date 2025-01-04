class UserResponse {
  int id;
  String username;
  String email;
  bool isPremium;
  bool isAdmin;
  DateTime createdAt;

  UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.isPremium,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        isPremium: json["isPremium"],
        isAdmin: json["isAdmin"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "isPremium": isPremium,
        "isAdmin": isAdmin,
        "createdAt": createdAt.toIso8601String(),
      };
}
