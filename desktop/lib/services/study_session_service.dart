import 'dart:convert';
import 'dart:io';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/study_session_response.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class StudySessionService extends BaseCRUDService<StudySessionResponse> {
  StudySessionService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/studysessions',
          client,
          (json) => StudySessionResponse.fromJson(json),
        );

  Future<PaginatedResponse<StudySessionResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? user,
    int? deck,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/studysessions?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&user=${user ?? ""}&deck=${deck ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final studySessions = PaginatedResponse<StudySessionResponse>.fromJson(
      jsonDecode(response.body),
      (json) => StudySessionResponse.fromJson(json),
    );

    return studySessions;
  }
}
