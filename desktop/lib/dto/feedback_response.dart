class FeedbackResponse {
  int id;
  String feedbackStatus;
  String title;
  String description;
  DateTime submittedAt;

  FeedbackResponse({
    required this.id,
    required this.feedbackStatus,
    required this.title,
    required this.description,
    required this.submittedAt,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      FeedbackResponse(
        id: json["id"],
        feedbackStatus: json["feedbackStatus"],
        title: json["title"],
        description: json["description"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "feedbackStatus": feedbackStatus,
        "title": title,
        "description": description,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
