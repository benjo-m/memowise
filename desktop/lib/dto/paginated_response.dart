class PaginatedResponse<T> {
  List<T> data;
  int pageIndex;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;

  PaginatedResponse({
    required this.data,
    required this.pageIndex,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginatedResponse(
      data: List<T>.from(json["data"].map((x) => fromJsonT(x))),
      pageIndex: json["pageIndex"],
      totalPages: json["totalPages"],
      hasPreviousPage: json["hasPreviousPage"],
      hasNextPage: json["hasNextPage"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": List<dynamic>.from(data.map((x) => (x as dynamic).toJson())),
      "pageIndex": pageIndex,
      "totalPages": totalPages,
      "hasPreviousPage": hasPreviousPage,
      "hasNextPage": hasNextPage,
    };
  }
}
