import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/dashboard_data.dart';
import 'package:http/http.dart' as http;

class AnalyticsService {
  Future<DashboardData> getDashboardData() async {
    final response = await http
        .get(Uri.parse('$baseUrl/analytics/dashboard-data'), headers: {
      'Content-Type': 'application/json',
    });
    final dashboardData = DashboardData.fromJson(jsonDecode(response.body));
    return dashboardData;
  }
}
