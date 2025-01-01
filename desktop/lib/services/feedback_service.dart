import 'dart:convert';
import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_paginated_response.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_status_update_request.dart';
import 'package:http/http.dart' as http;

class FeedbackService {
  Future<FeedbackPaginatedResponse> getAllFeedback(int page) async {
    final response = await http
        .get(Uri.parse('$baseUrl/feedback?page=$page&pageSize=15'), headers: {
      'Content-Type': 'application/json',
    });

    final feedbackPaginatedResponse =
        FeedbackPaginatedResponse.fromJson(jsonDecode(response.body));

    return feedbackPaginatedResponse;
  }

  Future<FeedbackResponse> getFeedbackById(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/feedback/$id'), headers: {
      'Content-Type': 'application/json',
    });

    final feedbackResponse =
        FeedbackResponse.fromJson(jsonDecode(response.body));

    return feedbackResponse;
  }

  Future<void> updateFeedbackStatus(
      int id, FeedbackStatusUpdateRequest req) async {
    await http.put(
      Uri.parse('$baseUrl/feedback/$id/status'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(req),
    );
  }

  Future<FeedbackResponse> removeFeedback(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/feedback/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final feedbackResponse =
        FeedbackResponse.fromJson(jsonDecode(response.body));

    return feedbackResponse;
  }
}
