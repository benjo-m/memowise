import 'dart:convert';
import 'dart:io';
import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/analytics_data.dart';
import 'package:desktop/dto/dashboard_data.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  Future<DashboardData> getDashboardData() async {
    final response = await http
        .get(Uri.parse('$baseUrl/analytics/dashboard-data'), headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
    });
    final dashboardData = DashboardData.fromJson(jsonDecode(response.body));
    return dashboardData;
  }

  Future<AnalyticsData> getAnalyticsData(int year) async {
    final response = await http.get(
        Uri.parse('$baseUrl/analytics/analytics-data?year=$year'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final analyticsData = AnalyticsData.fromJson(jsonDecode(response.body));
    return analyticsData;
  }
}
