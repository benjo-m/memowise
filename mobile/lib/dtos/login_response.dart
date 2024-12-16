class LoginResponse {
  int id;
  String username;
  String email;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
      };
}
