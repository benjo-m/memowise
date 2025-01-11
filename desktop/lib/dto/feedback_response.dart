class FeedbackResponse {
  int id;
  int userId;
  String feedbackStatus;
  String title;
  String description;
  DateTime submittedAt;
  bool isPremiumUser;

  FeedbackResponse({
    required this.isPremiumUser,
    required this.id,
    required this.userId,
    required this.feedbackStatus,
    required this.title,
    required this.description,
    required this.submittedAt,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      FeedbackResponse(
        isPremiumUser: json["isPremiumUser"],
        id: json["id"],
        userId: json["userId"],
        feedbackStatus: json["feedbackStatus"],
        title: json["title"],
        description: json["description"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "isPremiumUser": isPremiumUser,
        "id": id,
        "userId": userId,
        "feedbackStatus": feedbackStatus,
        "title": title,
        "description": description,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
