class PaymentRecordDto {
  String paymentIntentId;
  int userId;
  int amount;
  String currency;
  DateTime createdAt;

  PaymentRecordDto({
    required this.paymentIntentId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.createdAt,
  });

  factory PaymentRecordDto.fromJson(Map<String, dynamic> json) =>
      PaymentRecordDto(
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
