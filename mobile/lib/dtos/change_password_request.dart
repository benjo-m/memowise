class ChangePasswordRequest {
  String currentPassword;
  String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      ChangePasswordRequest(
        currentPassword: json["currentPassword"],
        newPassword: json["newPassword"],
      );

  Map<String, dynamic> toJson() => {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      };
}
