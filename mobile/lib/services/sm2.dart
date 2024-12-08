import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/card.dart';

class SM2 {
  CardStatsUpdateRequest sm2(int q, Card card) {
    var cardStatsUpdateRequest = CardStatsUpdateRequest.fromCard(card);

    // correct answer
    if (q >= 3) {
      if (card.repetitions == 0) {
        cardStatsUpdateRequest.interval = 1;
      } else if (card.repetitions == 1) {
        cardStatsUpdateRequest.interval = 6;
      } else {
        cardStatsUpdateRequest.interval =
            (card.interval * card.easeFactor).round();
      }
      cardStatsUpdateRequest.repetitions++;
      // incorrect answer
    } else {
      cardStatsUpdateRequest.repetitions = 0;
      cardStatsUpdateRequest.interval = 1;
    }

    var newEf = card.easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    cardStatsUpdateRequest.easeFactor = double.parse(newEf.toStringAsFixed(2));

    return cardStatsUpdateRequest;
  }
}
