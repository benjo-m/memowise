import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mobile/config/constants.dart';
import 'package:mobile/dtos/payment_record_create_request.dart';
import 'package:mobile/services/auth/current_user.dart';

class PaymentService {
  Future<void> savePaymentRecord(PaymentRecordCreateRequest req) async {
    await http.post(
      Uri.parse("$baseUrl/paymentrecords"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
      body: jsonEncode(req),
    );
  }
}
