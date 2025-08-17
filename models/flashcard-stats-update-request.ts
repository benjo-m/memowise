import { Flashcard } from "./flashcard";

export class FlashcardStatsUpdateRequest {
  id: number;
  repetitions: number;
  interval: number;
  ease_factor: number;
  due_date: Date;

  constructor(flashcard: Flashcard) {
    this.id = flashcard.id;
    this.repetitions = flashcard.repetitions;
    this.interval = flashcard.interval;
    this.ease_factor = flashcard.ease_factor;
    this.due_date = new Date(flashcard.due_date);
  }
}
