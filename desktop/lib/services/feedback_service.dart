import 'dart:convert';
import 'dart:io';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/feedback_response.dart';
import 'package:desktop/dto/feedback_status_update_request.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class FeedbackService extends BaseCRUDService<FeedbackResponse> {
  FeedbackService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/feedback',
          client,
          (json) => FeedbackResponse.fromJson(json),
        );

  Future<PaginatedResponse<FeedbackResponse>> getAll({
    int page = 1,
    String sortBy = "date",
    bool sortDescending = false,
    String status = "Any",
    String accountType = "any",
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/feedback?page=$page&pageSize=10&accountType=$accountType&sortBy=$sortBy&sortDescending=$sortDescending&status=$status'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final feedbackPaginatedResponse =
        PaginatedResponse<FeedbackResponse>.fromJson(
      jsonDecode(response.body),
      (json) => FeedbackResponse.fromJson(json),
    );

    return feedbackPaginatedResponse;
  }

  // Future<FeedbackResponse> getFeedbackById(int id) async {
  //   final response =
  //       await http.get(Uri.parse('$baseUrl/feedback/$id'), headers: {
  //     'Content-Type': 'application/json',
  //   });

  //   final feedbackResponse =
  //       FeedbackResponse.fromJson(jsonDecode(response.body));

  //   return feedbackResponse;
  // }

  Future<void> updateFeedbackStatus(
      int id, FeedbackStatusUpdateRequest req) async {
    await http.put(
      Uri.parse('$baseUrl/feedback/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(req),
    );
  }

  // Future<FeedbackResponse> removeFeedback(int id) async {
  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/feedback/$id'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   final feedbackResponse =
  //       FeedbackResponse.fromJson(jsonDecode(response.body));

  //   return feedbackResponse;
  // }
}
