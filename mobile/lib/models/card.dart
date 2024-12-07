enum CardStatus { New, Learning, Learned, Reviewing }

class Card {
  int id;
  String question;
  String answer;
  CardStatus status;
  int repetitions;
  int interval;
  num easeFactor;
  DateTime dueDate;

  Card({
    required this.id,
    required this.question,
    required this.answer,
    required this.status,
    required this.repetitions,
    required this.interval,
    required this.easeFactor,
    required this.dueDate,
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
      repetitions: json['repetitions'],
      interval: json['interval'],
      easeFactor: json['easeFactor'],
      dueDate: DateTime.parse(json['dueDate']));

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "status": status.toString().split('.').last,
        "repetitions": repetitions,
        "interval": interval,
        "easeFactor": easeFactor,
        "dueDate": dueDate
      };
}
