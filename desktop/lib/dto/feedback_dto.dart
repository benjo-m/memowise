class FeedbackDto {
  String status;
  String title;
  String description;
  DateTime submittedAt;

  FeedbackDto({
    required this.status,
    required this.title,
    required this.description,
    required this.submittedAt,
  });

  factory FeedbackDto.fromJson(Map<String, dynamic> json) => FeedbackDto(
        status: json["status"],
        title: json["title"],
        description: json["description"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "title": title,
        "description": description,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
