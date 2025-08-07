import { Flashcard } from "@/models/flashcard";

export const applySm2 = (flashcard: Flashcard, rating: number): Flashcard => {
  if (rating >= 3) {
    if (flashcard.repetitions == 0) {
      flashcard.interval = 1;
    } else if (flashcard.repetitions == 1) {
      flashcard.interval = 6;
    } else {
      flashcard.interval = Math.ceil(flashcard.interval * flashcard.ease_factor);
    }

    ++flashcard.repetitions;
    const newDueDate = new Date();
    newDueDate.setDate(newDueDate.getDate() + flashcard.interval);
    flashcard.due_date = newDueDate;
  } else {
    flashcard.repetitions = 0;
    flashcard.interval = 1;
  }

  const newEaseFactor = flashcard.ease_factor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));

  if (newEaseFactor < 1.3) {
    flashcard.ease_factor = 1.3;
  } else {
    flashcard.ease_factor = newEaseFactor;
  }

  printFlashcard(flashcard);

  return flashcard;
};

export const printFlashcard = (card: Flashcard) => {
  console.log(`
--------------------------------
Flashcard ID: ${card.id}
Deck ID: ${card.deck_id}
Front: ${card.front}
Back: ${card.back}

Repetitions: ${card.repetitions}
Interval: ${card.interval}
Ease Factor: ${card.ease_factor}
Due Date: ${card.due_date}

Front Image: ${card.front_image_url ? "Image" : "None"}
Back Image: ${card.back_image_url ? "Image" : "None"}
--------------------------------
  `);
};
