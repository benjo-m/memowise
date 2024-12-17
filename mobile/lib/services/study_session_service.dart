import 'dart:convert';
import 'dart:io';

import 'package:mobile/config/constants.dart';
import 'package:mobile/models/study_session.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth/current_user.dart';

class StudySessionService {
  Future<void> saveSession(StudySession studySession) async {
    await http.post(
      Uri.parse("$baseUrl/studysessions"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(studySession),
    );
  }
}
