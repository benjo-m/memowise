class FeedbackCreateRequest {
  int userId;
  String title;
  String description;

  FeedbackCreateRequest({
    required this.userId,
    required this.title,
    required this.description,
  });

  factory FeedbackCreateRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackCreateRequest(
        userId: json["userId"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "title": title,
        "description": description,
      };
}
