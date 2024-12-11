import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:mobile/models/study_session.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/services/auth/firebase_auth_provider.dart';

class StudySessionService {
  // final String baseUrl = 'http://10.0.2.2:5151/api/studysessions';
  final String baseUrl = 'http://localhost:5151/api/studysessions';

  Future<void> saveSession(StudySession studySession) async {
    String? token = await FirebaseAuthProvider().currentUser?.getIdToken();

    var b = jsonEncode(studySession);

    await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: b,
    );

    log(b);
  }
}
