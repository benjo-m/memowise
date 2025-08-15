import { Flashcard } from "@/models/flashcard";

export const applySm2 = (flashcard: Flashcard, rating: number): Flashcard => {
  const newEaseFactor = flashcard.ease_factor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));

  if (newEaseFactor < 1.3) {
    flashcard.ease_factor = 1.3;
  } else if (newEaseFactor > 2.5) {
    flashcard.ease_factor = 2.5;
  } else {
    flashcard.ease_factor = newEaseFactor;
  }

  if (rating >= 3) {
    if (flashcard.repetitions == 0) {
      flashcard.interval = 1;
    } else if (flashcard.repetitions == 1) {
      flashcard.interval = 4;
    } else {
      flashcard.interval = Math.ceil(flashcard.interval * flashcard.ease_factor);
    }

    ++flashcard.repetitions;
  } else {
    flashcard.repetitions = 0;
    flashcard.interval = 1;
  }

  if (rating > 3) {
    const newDueDate = new Date();
    newDueDate.setDate(newDueDate.getDate() + flashcard.interval);
    flashcard.due_date = newDueDate;
    flashcard.due_today = false;
  }

  return flashcard;
};
