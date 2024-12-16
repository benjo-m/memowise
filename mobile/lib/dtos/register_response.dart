class RegisterResponse {
  int id;
  String username;
  String email;

  RegisterResponse({
    required this.id,
    required this.username,
    required this.email,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
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
