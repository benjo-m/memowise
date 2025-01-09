class LoginRecordDto {
  int userId;
  DateTime loginDateTime;

  LoginRecordDto({
    required this.userId,
    required this.loginDateTime,
  });

  factory LoginRecordDto.fromJson(Map<String, dynamic> json) => LoginRecordDto(
        userId: json["userId"],
        loginDateTime: DateTime.parse(json["loginDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "loginDateTime": loginDateTime.toIso8601String(),
      };
}
