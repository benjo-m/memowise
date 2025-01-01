class FeedbackStatusUpdateRequest {
  String status;

  FeedbackStatusUpdateRequest({
    required this.status,
  });

  factory FeedbackStatusUpdateRequest.fromJson(Map<String, dynamic> json) =>
      FeedbackStatusUpdateRequest(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
