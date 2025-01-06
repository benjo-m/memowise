class FeedbackCreateRequest {
  String title;
  String description;
  String status;
  DateTime submittedAt;

  FeedbackCreateRequest({
    required this.title,
    required this.description,
    required this.status,
    required this.submittedAt,
  });

  factory FeedbackCreateRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackCreateRequest(
        title: json["title"],
        description: json["description"],
        status: json["status"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "status": status,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
