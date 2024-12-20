class DeleteUserRequest {
  String password;

  DeleteUserRequest({
    required this.password,
  });

  factory DeleteUserRequest.fromJson(Map<String, dynamic> json) =>
      DeleteUserRequest(
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
      };
}
