class DashboardData {
  UserGrowth userGrowth;
  UserDistribution userDistribution;

  DashboardData({
    required this.userGrowth,
    required this.userDistribution,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        userGrowth: UserGrowth.fromJson(json["userGrowth"]),
        userDistribution: UserDistribution.fromJson(json["userDistribution"]),
      );

  Map<String, dynamic> toJson() => {
        "userGrowth": userGrowth.toJson(),
        "userDistribution": userDistribution.toJson(),
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
