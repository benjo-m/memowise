import 'package:mobile/dtos/payment_intent_response.dart';

class PaymentRecordCreateRequest {
  String paymentIntentId;
  int userId;
  int amount;
  String currency;
  DateTime createdAt;

  PaymentRecordCreateRequest({
    required this.paymentIntentId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  PaymentRecordCreateRequest.fromPaymentIntentResponse(
      PaymentIntentResponse paymentIntentResponse)
      : paymentIntentId = paymentIntentResponse.paymentIntentId,
        userId = paymentIntentResponse.userId,
        amount = paymentIntentResponse.amount,
        currency = paymentIntentResponse.currency,
        createdAt = paymentIntentResponse.createdAt;

  factory PaymentRecordCreateRequest.fromJson(Map<String, dynamic> json) =>
      PaymentRecordCreateRequest(
        paymentIntentId: json["paymentIntentId"],
        userId: json["userId"],
        amount: json["amount"],
        currency: json["currency"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentIntentId": paymentIntentId,
        "userId": userId,
        "amount": amount,
        "currency": currency,
        "createdAt": createdAt.toIso8601String(),
      };
}
