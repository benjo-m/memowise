import 'dart:convert';
import 'dart:io';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class LoginRecordService extends BaseCRUDService<LoginRecordResponse> {
  LoginRecordService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/loginrecords',
          client,
          (json) => LoginRecordResponse.fromJson(json),
        );

  Future<PaginatedResponse<LoginRecordResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? user,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/loginrecords?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&user=${user ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final loginRecords = PaginatedResponse<LoginRecordResponse>.fromJson(
      jsonDecode(response.body),
      (json) => LoginRecordResponse.fromJson(json),
    );

    return loginRecords;
  }
}
