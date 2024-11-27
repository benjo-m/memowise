enum CardStatus { New, Learning, Learned }

class Card {
  int id;
  String question;
  String answer;
  CardStatus status;

  Card({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        status: CardStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json["status"],
          orElse: () =>
              throw ArgumentError('Invalid CardStatus: ${json["status"]}'),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "status": status.toString().split('.').last,
      };
}
