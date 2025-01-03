class PaymentRecordResponse {
  int id;
  String paymentIntentId;
  int userId;
  int amount;
  String currency;
  DateTime createdAt;

  PaymentRecordResponse({
    required this.id,
    required this.paymentIntentId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  factory PaymentRecordResponse.fromJson(Map<String, dynamic> json) =>
      PaymentRecordResponse(
        id: json["id"],
        paymentIntentId: json["paymentIntentId"],
        userId: json["userId"],
        amount: json["amount"],
        currency: json["currency"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentIntentId": paymentIntentId,
        "userId": userId,
        "amount": amount,
        "currency": currency,
        "createdAt": createdAt.toIso8601String(),
      };
}
