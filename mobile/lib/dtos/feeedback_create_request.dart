class FeedbackCreateRequest {
  String title;
  String description;
  String status;
  int userId;
  DateTime submittedAt;
  bool isPremiumUser;

  FeedbackCreateRequest({
    required this.isPremiumUser,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.submittedAt,
  });

  factory FeedbackCreateRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackCreateRequest(
        isPremiumUser: json["isPremiumUser"],
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        submittedAt: DateTime.parse(json["submittedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "isPremiumUser": isPremiumUser,
        "userId": userId,
        "title": title,
        "description": description,
        "status": status,
        "submittedAt": submittedAt.toIso8601String(),
      };
}
