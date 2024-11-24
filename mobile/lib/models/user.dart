class AppUser {
  String username;
  String email;

  AppUser({required this.username, required this.email});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'username': String username,
        'email': String email,
      } =>
        AppUser(
          username: username,
          email: email,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}
