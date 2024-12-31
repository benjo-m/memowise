import 'dart:convert';
import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_paginated_response.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  Future<FeedbackPaginatedResponse> getFeedback(int page) async {
    final response = await http
        .get(Uri.parse('$baseUrl/feedback?page=$page&pageSize=15'), headers: {
      'Content-Type': 'application/json',
    });

    final feedbackResponse =
        FeedbackPaginatedResponse.fromJson(jsonDecode(response.body));

    return feedbackResponse;
  }
}
