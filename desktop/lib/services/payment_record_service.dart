import 'dart:convert';
import 'dart:io';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/services/base_crud_service.dart';
import 'package:http/http.dart' as http;

class PaymentRecordService extends BaseCRUDService<PaymentRecordResponse> {
  PaymentRecordService(String baseUrl, http.Client client)
      : super(
          '$baseUrl/paymentrecords',
          client,
          (json) => PaymentRecordResponse.fromJson(json),
        );

  Future<PaginatedResponse<PaymentRecordResponse>> getAll({
    int page = 1,
    String sortBy = "id",
    bool sortDescending = false,
    int? user,
  }) async {
    final response = await http.get(
        Uri.parse(
            '$baseUrl/paymentrecords?page=$page&pageSize=10&sortBy=$sortBy&sortDescending=$sortDescending&user=${user ?? ""}'),
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
        });

    final paymentRecords = PaginatedResponse<PaymentRecordResponse>.fromJson(
      jsonDecode(response.body),
      (json) => PaymentRecordResponse.fromJson(json),
    );

    return paymentRecords;
  }
}
