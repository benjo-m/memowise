class DashboardData {
  UserGrowth userGrowth;
  UserDistribution userDistribution;
  NewUsers newUsers;
  ActiveUsers activeUsers;
  FeedbackCount feedbackCount;

  DashboardData({
    required this.userGrowth,
    required this.userDistribution,
    required this.newUsers,
    required this.activeUsers,
    required this.feedbackCount,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        userGrowth: UserGrowth.fromJson(json["userGrowth"]),
        userDistribution: UserDistribution.fromJson(json["userDistribution"]),
        newUsers: NewUsers.fromJson(json["newUsers"]),
        activeUsers: ActiveUsers.fromJson(json["activeUsers"]),
        feedbackCount: FeedbackCount.fromJson(json["feedbackCount"]),
      );

  Map<String, dynamic> toJson() => {
        "userGrowth": userGrowth.toJson(),
        "userDistribution": userDistribution.toJson(),
        "newUsers": newUsers.toJson(),
        "activeUsers": activeUsers.toJson(),
        "feedbackCount": feedbackCount.toJson(),
      };
}

class ActiveUsers {
  int count;
  int change;

  ActiveUsers({
    required this.count,
    required this.change,
  });

  factory ActiveUsers.fromJson(Map<String, dynamic> json) => ActiveUsers(
        count: json["count"],
        change: json["change"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "change": change,
      };
}

class FeedbackCount {
  int pendingFeedback;
  int savedFeedback;

  FeedbackCount({
    required this.pendingFeedback,
    required this.savedFeedback,
  });

  factory FeedbackCount.fromJson(Map<String, dynamic> json) => FeedbackCount(
        pendingFeedback: json["pendingFeedback"],
        savedFeedback: json["savedFeedback"],
      );

  Map<String, dynamic> toJson() => {
        "pendingFeedback": pendingFeedback,
        "savedFeedback": savedFeedback,
      };
}

class NewUsers {
  int userCount;
  int userCountChange;
  int premiumUserCount;
  int premiumUserCountChange;

  NewUsers({
    required this.userCount,
    required this.userCountChange,
    required this.premiumUserCount,
    required this.premiumUserCountChange,
  });

  factory NewUsers.fromJson(Map<String, dynamic> json) => NewUsers(
        userCount: json["userCount"],
        userCountChange: json["userCountChange"],
        premiumUserCount: json["premiumUserCount"],
        premiumUserCountChange: json["premiumUserCountChange"],
      );

  Map<String, dynamic> toJson() => {
        "userCount": userCount,
        "userCountChange": userCountChange,
        "premiumUserCount": premiumUserCount,
        "premiumUserCountChange": premiumUserCountChange,
      };
}

class UserDistribution {
  int freeUsersPercentage;
  int premiumUsersPercentage;

  UserDistribution({
    required this.freeUsersPercentage,
    required this.premiumUsersPercentage,
  });

  factory UserDistribution.fromJson(Map<String, dynamic> json) =>
      UserDistribution(
        freeUsersPercentage: json["freeUsersPercentage"],
        premiumUsersPercentage: json["premiumUsersPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "freeUsersPercentage": freeUsersPercentage,
        "premiumUsersPercentage": premiumUsersPercentage,
      };
}

class UserGrowth {
  List<UserGrowthDataPoint> data;

  UserGrowth({
    required this.data,
  });

  factory UserGrowth.fromJson(Map<String, dynamic> json) => UserGrowth(
        data: List<UserGrowthDataPoint>.from(
            json["data"].map((x) => UserGrowthDataPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UserGrowthDataPoint {
  int year;
  int month;
  int count;

  UserGrowthDataPoint({
    required this.year,
    required this.month,
    required this.count,
  });

  factory UserGrowthDataPoint.fromJson(Map<String, dynamic> json) =>
      UserGrowthDataPoint(
        year: json["year"],
        month: json["month"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "count": count,
      };
}
