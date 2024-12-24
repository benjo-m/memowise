class LoginResponse {
  int id;
  String username;
  String email;
  bool isPremium;
  bool isAdmin;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.isPremium,
    required this.isAdmin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
