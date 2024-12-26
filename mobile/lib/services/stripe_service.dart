import 'dart:developer';
import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile/config/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/user_service.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      String? paymentIntentClientSecret = await createPaymentIntent();
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret!,
        merchantDisplayName: "MemoWise",
      ));
      await _processPayment();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> createPaymentIntent() async {
    final response = await http.post(
      Uri.parse('$baseUrl/stripe/premium-upgrade'),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: CurrentUser.authHeader ?? "",
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create payment intent');
    }

    final clientSecret = jsonDecode(response.body)['clientSecret'];

    return clientSecret;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await UserService().upgradeToPremium();
    } catch (e) {
      log(e.toString());
    }
  }
}
