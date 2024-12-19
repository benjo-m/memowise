class UpdateUserRequest {
  String username;
  String email;
  String password;

  UpdateUserRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      UpdateUserRequest(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
      };
}
