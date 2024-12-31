import 'package:mobile/dtos/feeedback_create_request.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/config/constants.dart';
import 'package:mobile/services/auth/current_user.dart';

class FeedbackService {
  Future<void> postFeedback(FeedbackCreateRequest feedbackCreateRequest) async {
    await http.post(Uri.parse("$baseUrl/feedback"),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        },
        body: jsonEncode(feedbackCreateRequest));
  }
}
