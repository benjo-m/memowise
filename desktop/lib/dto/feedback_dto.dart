class FeedbackDto {
  int userId;
  String status;
  String title;
  String description;
  DateTime submittedAt;

  FeedbackDto({
    required this.userId,
    required this.status,
    required this.title,
    required this.description,
    required this.submittedAt,
  });

  factory FeedbackDto.fromJson(Map<String, dynamic> json) => FeedbackDto(
        userId: json["userId"],
        status: json["status"],
        title: json["title"],
        description: json["description"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "status": status,
        "title": title,
        "description": description,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
