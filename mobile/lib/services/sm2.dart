import 'package:mobile/dtos/card_stats_update_request.dart';
import 'package:mobile/models/card.dart';

class SM2 {
  CardStatsUpdateRequest sm2(int q, Card card) {
    num easeFactor = card.cardStats.easeFactor;
    int interval = card.cardStats.interval;
    int repetitions = card.cardStats.repetitions;

    // correct answer
    if (q >= 3) {
      if (repetitions == 0) {
        interval = 1;
      } else if (repetitions == 1) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }
      repetitions++;
      // incorrect answer
    } else {
      repetitions = 0;
      interval = 1;
    }

    easeFactor = easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));

    if (easeFactor < 1.3) {
      easeFactor = 1.3;
    } else {
      easeFactor = double.parse(easeFactor.toStringAsFixed(2));
    }

    return CardStatsUpdateRequest(
        cardId: card.id,
        easeFactor: easeFactor,
        interval: interval,
        repetitions: repetitions);
  }
}
