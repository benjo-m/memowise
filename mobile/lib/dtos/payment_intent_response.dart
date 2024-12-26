class PaymentIntentResponse {
  String paymentIntentId;
  String clientSecret;
  int userId;
  int amount;
  String currency;
  DateTime createdAt;

  PaymentIntentResponse({
    required this.paymentIntentId,
    required this.clientSecret,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentIntentResponse(
        paymentIntentId: json["paymentIntentId"],
        clientSecret: json["clientSecret"],
        userId: json["userId"],
        amount: json["amount"],
        currency: json["currency"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentIntentId": paymentIntentId,
        "clientSecret": clientSecret,
        "userId": userId,
        "amount": amount,
        "currency": currency,
        "createdAt": createdAt.toIso8601String(),
      };
}
