class FeedbackCreateRequest {
  String title;
  String description;

  FeedbackCreateRequest({
    required this.title,
    required this.description,
  });

  factory FeedbackCreateRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackCreateRequest(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
