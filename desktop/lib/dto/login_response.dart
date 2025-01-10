class LoginResponse {
  int id;
  String username;
  String email;
  bool isPremium;
  bool isAdmin;
  bool isSuperAdmin;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.isPremium,
    required this.isAdmin,
    required this.isSuperAdmin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        isPremium: json["isPremium"],
        isAdmin: json["isAdmin"],
        isSuperAdmin: json["isSuperAdmin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "isPremium": isPremium,
        "isAdmin": isAdmin,
        "isSuperAdmin": isSuperAdmin,
      };
}
