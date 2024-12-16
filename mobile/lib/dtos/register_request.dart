class RegisterRequest {
  String username;
  String email;
  String password;
  String passwordConfirmation;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        passwordConfirmation: json["passwordConfirmation"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "passwordConfirmation": passwordConfirmation,
      };
}
