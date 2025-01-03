import 'dart:convert';
import 'dart:developer';

import 'package:desktop/config/constants.dart';
import 'package:desktop/dto/login_record_response.dart';
import 'package:desktop/dto/paginated_response.dart';
import 'package:desktop/dto/payment_record_response.dart';
import 'package:http/http.dart' as http;

class PaymentRecordService {
  Future<PaginatedResponse<PaymentRecordResponse>> getAllPaymentRecords({
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
        });

    final paymentRecords = PaginatedResponse<PaymentRecordResponse>.fromJson(
      jsonDecode(response.body),
      (json) => PaymentRecordResponse.fromJson(json),
    );

    return paymentRecords;
  }
}
