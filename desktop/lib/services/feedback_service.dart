import 'dart:convert';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_status_update_request.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class FeedbackService extends BaseCRUDService<FeedbackResponse> {
  FeedbackService(super.baseUrl, super.client);

  Future<PaginatedResponse<FeedbackResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    String status = "Any",
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/feedback?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&status=$status'),
        headers: {
          'Content-Type': 'application/json',
        });

    final feedbackPaginatedResponse =
        PaginatedResponse<FeedbackResponse>.fromJson(
      jsonDecode(response.body),
      (json) => FeedbackResponse.fromJson(json),
    );

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
