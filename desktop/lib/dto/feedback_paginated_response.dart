import 'package:desktop/dto/feedback_response.dart';

class FeedbackPaginatedResponse {
  List<FeedbackResponse> data;
  int pageIndex;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  FeedbackPaginatedResponse({
    required this.data,
    required this.pageIndex,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory FeedbackPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      FeedbackPaginatedResponse(
        data: List<FeedbackResponse>.from(
            json["data"].map((x) => FeedbackResponse.fromJson(x))),
        pageIndex: json["pageIndex"],
        totalPages: json["totalPages"],
        hasPreviousPage: json["hasPreviousPage"],
        hasNextPage: json["hasNextPage"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pageIndex": pageIndex,
        "totalPages": totalPages,
        "hasPreviousPage": hasPreviousPage,
        "hasNextPage": hasNextPage,
      };
}
