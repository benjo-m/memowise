import 'dart:convert';
import 'dart:io';

import 'package:mobile/config/constants.dart';
import 'package:mobile/models/study_session.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth/firebase_auth_provider.dart';

class StudySessionService {
  Future<void> saveSession(StudySession studySession) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    await http.post(
      Uri.parse("$baseUrl/studysessions"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(studySession),
    );
  }
}
