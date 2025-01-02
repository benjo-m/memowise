class LoginRecordResponse {
  int id;
  int userId;
  DateTime loginDateTime;

  LoginRecordResponse({
    required this.id,
    required this.userId,
    required this.loginDateTime,
  });

  factory LoginRecordResponse.fromJson(Map<String, dynamic> json) =>
      LoginRecordResponse(
        id: json["id"],
        userId: json["userId"],
        loginDateTime: DateTime.parse(json["loginDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "loginDateTime": loginDateTime.toIso8601String(),
      };
}
