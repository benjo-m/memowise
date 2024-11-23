class User {
  String username;
  String email;

  User({required this.username, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'email': String email,
      } =>
        User(
          username: username,
          email: email,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}
