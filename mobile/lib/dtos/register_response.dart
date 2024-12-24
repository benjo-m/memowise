class RegisterResponse {
  int id;
  String username;
  String email;
  bool isPremium;
  bool isAdmin;

  RegisterResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.isPremium,
    required this.isAdmin,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        isPremium: json["isPremium"],
        isAdmin: json["isAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "isPremium": isPremium,
        "isAdmin": isAdmin,
      };
}
