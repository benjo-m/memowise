import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/dtos/payment_intent_response.dart';
import 'package:mobile/dtos/payment_record_create_request.dart';
import 'dart:convert';

import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/payment_service.dart';
import 'package:mobile/services/user_service.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      PaymentIntentResponse paymentIntentResponse = await createPaymentIntent();
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentResponse.clientSecret,
        merchantDisplayName: "MemoWise",
      ));
      await _processPayment();
      await UserService().upgradeToPremium(CurrentUser.userId ?? -1);
      await PaymentService().savePaymentRecord(
          PaymentRecordCreateRequest.fromPaymentIntentResponse(
              paymentIntentResponse));
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentIntentResponse> createPaymentIntent() async {
    final response = await http.post(
      Uri.parse('$baseUrl/stripe/payment-intent/${CurrentUser.userId}'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent');
    }

    return PaymentIntentResponse.fromJson(jsonDecode(response.body));
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      rethrow;
    }
  }
}
