class UpdateUserRequest {
  String username;
  String email;

  UpdateUserRequest({
    required this.username,
    required this.email,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      UpdateUserRequest(
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
      };
}
